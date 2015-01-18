#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gump.h"

#define DEBUG 0
#define MINBOX 100000
#define RANK_MAX 100000000

// DEBUGGING --------------------------------------------------------------------------------------

void printContext(GumpSearchContext* sc) {
	int i = 0;
	printf("\n%d Points\n", sc->N);
	printf("xsort:\n");
	for (i = 0; i < sc->N; i++) {
		printf("%d, %d, %f, %f\n", sc->xsort[i].id, sc->xsort[i].rank, sc->xsort[i].x, sc->xsort[i].y);
	}
	printf("ysort:\n");
	for (i = 0; i < sc->N; i++) {
		printf("%d, %d, %f, %f\n", sc->ysort[i].id, sc->ysort[i].rank, sc->ysort[i].x, sc->ysort[i].y);
	}
	printf("ranksort:\n");
	for (i = 0; i < sc->N; i++) {
		printf("%d, %d, %f, %f\n", sc->ranksort[i].id, sc->ranksort[i].rank, sc->ranksort[i].x, sc->ranksort[i].y);
	}
}

void printRect(Rect rect) {
	printf("[%f, %f, %f, %f]\n", rect.lx, rect.hx, rect.ly, rect.hy);
}

void printPoints(Point* points, int n) {
	for (int i = 0; i < n; i++) {
		printf("%d, %d, %f, %f\n", points[i].id, points[i].rank, points[i].x, points[i].y);
	}
}



// SORT ROUTINES ----------------------------------------------------------------------------------

int xCompare(const void* a, const void* b) {
	float diff = ((Point*)a)->x - ((Point*)b)->x;
	return diff > 0 ? 1 : diff < 0 ? -1 : 0;
}

int yCompare(const void* a, const void* b) {
	float diff = ((Point*)a)->y - ((Point*)b)->y;
	return diff > 0 ? 1 : diff < 0 ? -1 : 0;
}

inline int rankCompare(const void* a, const void* b) {
	return ((Point*)a)->rank - ((Point*)b)->rank;
}



// HELPER FUNCTIONS -------------------------------------------------------------------------------

inline bool isHit(const Rect* r, Point* p) {
	return p->x >= r->lx && p->x <= r->hx && p->y >= r->ly && p->y <= r->hy;
}

inline bool isHitX(const Rect* r, Point* p) {
	return p->x >= r->lx && p->x <= r->hx;
}

inline bool isHitY(const Rect* r, Point* p) {
	return p->y >= r->ly && p->y <= r->hy;
}

int _rankmax = 0;

inline bool isHitXMinRank(const Rect* r, Point* p) {
	return p->rank < _rankmax && p->x >= r->lx && p->x <= r->hx;
}

inline bool isHitYMinRank(const Rect* r, Point* p) {
	return p->rank < _rankmax && p->y >= r->ly && p->y <= r->hy;
}

inline bool isRectInside(Rect* r1, Rect* r2) {
	return r2->lx >= r1->lx && r2->lx <= r1->hx && r2->ly >= r1->ly && r2->ly <= r1->hy &&
	       r2->hx >= r1->lx && r2->hx <= r1->hx && r2->hy >= r1->ly && r2->hy <= r1->hy;
}

inline bool isRectOverlap(Rect* r1, Rect* r2) {
	return r1->lx < r2->hx && r1->hx > r2->lx && r1->ly < r2->hy && r1->hy > r2->ly;
}

int bsearch(Point p[], bool xOrY, bool minOrMax, float v, int imin, int imax) {
	while (imax >= imin) {
		int imid = (imin + imax) / 2;
		float val = xOrY ? p[imid].x : p[imid].y;
		if (val == v) {
			if (minOrMax) {
				while (imid > imin && (xOrY ? p[imid-1].x : p[imid-1].y) == v) imid--;
				return imid;
			} else {
				while (imid < imax && (xOrY ? p[imid+1].x : p[imid+1].y) == v) imid++;
				return imid;
			}
		}
		else if (val < v) imin = imid + 1;
		else imax = imid - 1;
	}
	return minOrMax ? imin : imax;
}

int intersect(Point p1[], Point p2[], int n1, int n2, int max, Point* out) {
	int i = 0, j = 0, n = 0;
	qsort(p1, n1, sizeof(Point), rankCompare);
	qsort(p2, n2, sizeof(Point), rankCompare);
	while (i < n1 && j < n2) {
		int rank1 = p1[i].rank;
		int rank2 = p2[j].rank;
		if (rank1 < rank2) i++;
		else if (rank2 < rank1) j++;
		else {
			out[n] = p1[i];
			i++; j++; n++;
			if (n >= max) return n;
		}
	}
	return n;
}

int32_t findHits(const Rect* rect, Point* in, int n, Point* out, int count, bool (*hitcheck)(const Rect* r, Point* p)) {
	int i = 0;
	int hits = 0;

	// if fewer points in test buffer than allowed hits, use all hits
	if (n <= count) {
		for (int i = 0; i < n; i++) {
			Point p = in[i];
			if (hitcheck(rect, &p)) {
				out[hits] = p;
				hits++;
			}
		}
		qsort(out, hits, sizeof(Point), rankCompare);
		return hits;
	}

	int j = 0;
	int max = -1;
	int maxloc = -1;

	// start by filling out with the first count hits from in
	while (i < n && hits < count) {
		Point p = in[i];
		if (hitcheck(rect, &p)) {
			out[hits] = p;
			if (p.rank > max) {
				max = p.rank;
				maxloc = hits;
			}
			hits++;
		}
		i++;
	}

	// did we exhaust in
	if (i == n) {
		qsort(out, hits, sizeof(Point), rankCompare);
		return hits;
	}

	// search through the remaining points in in
	while (i < n) {
		Point p = in[i];
		if (p.rank > max) {
			i++;
			continue;
		}

		if (hitcheck(rect, &p)) {
			// replace previous max with this point
			out[maxloc] = p;

			// find new max
			max = -1;
			maxloc = -1;
			for (j = 0; j < count; j++) {
				if (out[j].rank > max) {
					max = out[j].rank;
					maxloc = j;
				}
			}
		}
		i++;
	}

	qsort(out, count, sizeof(Point), rankCompare);
	return count;
}



// SEARCH IMPLEMENTATIONS -------------------------------------------------------------------------

// baseline search - search full list of points, sorted by rank increasing
int32_t searchBaseline(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	// FILE *f = fopen("rects.csv", "a");
	// fprintf(f, "%f,%f,%f,%f\n", rect.lx, rect.hx, rect.ly, rect.hy);
	// fclose(f);

	int32_t n = 0;
	int i = 0;
	while (n < count && i < sc->N) {
		Point p = sc->ranksort[i];
		if (isHit(&rect, &p)) {
			out_points[n] = p;
			n++;
		}
		i++;
	}

	return n;
}


// binary search - narrow search to points in x range, y range, and check smaller set
int32_t searchBinary(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int32_t n = 0;
	int xidxl = bsearch(sc->xsort, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	float ratio = (float)(nx < ny ? nx : ny) / (float)sc->N;
	if (ratio > .01f) return searchBaseline(sc, rect, count, out_points);

	if (nx < ny) return findHits(&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
	else return findHits(&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
}

// tree search - build quadtree and narrow use precomputed solutions as starting point
void treeHits(GumpSearchContext* sc, TreeNode* node, const Rect rect) {
	// if this node is fully contained within the rect, return this nodes hits
	if (isRectInside((Rect*)(&rect), node->rect)) {
		memcpy(node->child20, node->my20, node->myN * sizeof(Point));
		node->childN = node->myN;
		if (sc->treeximin == -1 || node->ximin < sc->treeximin) sc->treeximin = node->ximin;
		if (sc->treeximax == -1 || node->ximax > sc->treeximax) sc->treeximax = node->ximax;
		if (sc->treeyimin == -1 || node->yimin < sc->treeyimin) sc->treeyimin = node->yimin;
		if (sc->treeyimax == -1 || node->yimax > sc->treeyimax) sc->treeyimax = node->yimax;
		return;
	}

	// if this node doesn't overlap the rect at all, return null
	if (!isRectOverlap((Rect*)(&rect), node->rect)) {
		node->childN = 0;
		return;
	}

	// recurse on the subtrees
	if (node->tr) treeHits(sc, node->tr, rect);
	if (node->tl) treeHits(sc, node->tl, rect);
	if (node->bl) treeHits(sc, node->bl, rect);
	if (node->br) treeHits(sc, node->br, rect);

	// merge results of children
	int tri = 0, tli = 0, bli = 0, bri = 0;
	int trr = RANK_MAX;
	int tlr = RANK_MAX;
	int blr = RANK_MAX;
	int brr = RANK_MAX;
	node->childN = 0;
	while (node->childN < 20) {
		if (node->tr && tri < node->tr->childN) trr = node->tr->child20[tri].rank; else trr = RANK_MAX;
		if (node->tl && tli < node->tl->childN) tlr = node->tl->child20[tli].rank; else tlr = RANK_MAX;
		if (node->bl && bli < node->bl->childN) blr = node->bl->child20[bli].rank; else blr = RANK_MAX;
		if (node->br && bri < node->br->childN) brr = node->br->child20[bri].rank; else brr = RANK_MAX;

		if (trr == RANK_MAX && tlr == RANK_MAX && blr == RANK_MAX && brr == RANK_MAX) break;

		if      (trr < tlr && trr < blr && trr < brr) { node->child20[node->childN] = node->tr->child20[tri]; tri++; }
		else if (tlr < trr && tlr < blr && tlr < brr) { node->child20[node->childN] = node->tl->child20[tli]; tli++; }
		else if (blr < trr && blr < tlr && blr < brr) { node->child20[node->childN] = node->bl->child20[bli]; bli++; }
		else if (brr < trr && brr < tlr && brr < blr) { node->child20[node->childN] = node->br->child20[bri]; bri++; }

		node->childN++;
	}
}

int32_t searchTree(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	// find x and y index bounds
	int ximin = bsearch(sc->xsort, true, true, rect.lx, 0, sc->N);
	int ximax = bsearch(sc->xsort, true, false, rect.hx, 0, sc->N);
	int yimin = bsearch(sc->ysort, false, true, rect.ly, 0, sc->N);
	int yimax = bsearch(sc->ysort, false, false, rect.hy, 0, sc->N);
	int nx = ximax - ximin + 1;
	int ny = yimax - yimin + 1;

	if (DEBUG) printf("maps to (%d,%d,%d,%d)\n", ximin, ximax, yimin, yimax);

	if (nx == 0 || ny == 0) return 0;

	int smallside = nx < ny ? nx : ny;
	float ratio = (float)smallside / (float)sc->N;
	if (ratio > .3f) return searchBaseline(sc, rect, count, out_points);
	else if (smallside < 2*MINBOX) {
		if (nx < ny) return findHits(&rect, &sc->xsort[ximin], nx, out_points, count, isHitY);
		else return findHits(&rect, &sc->ysort[yimin], ny, out_points, count, isHitX);
	} else {
		sc->treeximin = -1;
		sc->treeximax = -1;
		sc->treeyimin = -1;
		sc->treeyimax = -1;

		// find hits in tree
		treeHits(sc, sc->root, rect);

		// find the leftover hits - the ones outside of the treenodes
		_rankmax = sc->root->childN > 0 ? sc->root->child20[sc->root->childN-1].rank : RANK_MAX;
		const struct Rect lrect = {
			.lx = sc->xsort[ximin].x,
			.ly = sc->ysort[yimin].y,
			.hx = sc->xsort[sc->treeximin-1].x,
			.hy = sc->ysort[yimax].y
		};
		int ln = findHits(&lrect, &sc->xsort[ximin], sc->treeximin - ximin, sc->lbox, count, isHitYMinRank);
		const struct Rect rrect = {
			.lx = sc->xsort[sc->treeximax+1].x,
			.ly = sc->ysort[yimin].y,
			.hx = sc->xsort[ximax].x,
			.hy = sc->ysort[yimax].y
		};
		int rn = findHits(&rrect, &sc->xsort[sc->treeximax+1], ximax - sc->treeximax + 2, sc->rbox, count, isHitYMinRank);
		const struct Rect trect = {
			.lx = sc->xsort[sc->treeximin].x,
			.ly = sc->ysort[sc->treeyimax+1].y,
			.hx = sc->xsort[sc->treeximax].x,
			.hy = sc->ysort[yimax].y
		};
		int tn = findHits(&trect, &sc->ysort[sc->treeyimax+1], yimax - sc->treeyimax + 2, sc->tbox, count, isHitXMinRank);
		const struct Rect brect = {
			.lx = sc->xsort[sc->treeximin].x,
			.ly = sc->ysort[yimin].y,
			.hx = sc->xsort[sc->treeximax].x,
			.hy = sc->ysort[sc->treeyimin-1].y
		};
		int bn = findHits(&brect, &sc->ysort[yimin], sc->treeyimin - yimin, sc->bbox, count, isHitXMinRank);

		int N = 0;
		int ni = 0, li = 0, ri = 0, ti = 0, bi = 0;
		int nr = RANK_MAX, lr = RANK_MAX, rr = RANK_MAX, tr = RANK_MAX, br = RANK_MAX;
		while (N < 20) {
			if (ni < sc->root->childN) nr = sc->root->child20[ni].rank; else nr = RANK_MAX;
			if (li < ln) lr = sc->lbox[li].rank; else lr = RANK_MAX;
			if (ri < rn) rr = sc->rbox[ri].rank; else rr = RANK_MAX;
			if (ti < tn) tr = sc->tbox[ti].rank; else tr = RANK_MAX;
			if (bi < bn) br = sc->bbox[bi].rank; else br = RANK_MAX;

			if (nr == RANK_MAX && lr == RANK_MAX && rr == RANK_MAX && tr == RANK_MAX && br == RANK_MAX) break;

			if      (nr < lr && nr < rr && nr < tr && nr < br) { out_points[N] = sc->root->child20[ni]; ni++; }
			else if (lr < nr && lr < rr && lr < tr && lr < br) { out_points[N] = sc->lbox[li]; li++; }
			else if (rr < nr && rr < lr && rr < tr && rr < br) { out_points[N] = sc->rbox[ri]; ri++; }
			else if (tr < nr && tr < lr && tr < rr && tr < br) { out_points[N] = sc->tbox[ti]; ti++; }
			else if (br < nr && br < lr && br < rr && br < tr) { out_points[N] = sc->bbox[bi]; bi++; }

			N++;
		}

		return N;
	}
}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------
int nodes = 0;

TreeNode* buildNode(GumpSearchContext* sc, int ximin, int ximax, int yimin, int yimax) {
	nodes++;
	TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
	node->ximin = ximin;
	node->ximax = ximax;
	node->yimin = yimin;
	node->yimax = yimax;
	node->tr = NULL;
	node->tl = NULL;
	node->bl = NULL;
	node->br = NULL;

	// compute top 20 in this region
	int nx = ximax - ximin + 1;
	int ny = yimax - yimin + 1;
	const struct Rect r = {
		.lx = sc->xsort[ximin].x,
		.ly = sc->ysort[yimin].y,
		.hx = sc->xsort[ximax].x,
		.hy = sc->ysort[yimax].y
	};

	node->rect = (Rect*)malloc(sizeof(Rect));
	node->rect->lx = r.lx;
	node->rect->ly = r.ly;
	node->rect->hx = r.hx;
	node->rect->hy = r.hy;
	node->my20 = (Point*)calloc(20, sizeof(Point));
	node->myN = searchBinary(sc, r, 20, node->my20);
	node->child20 = (Point*)calloc(20, sizeof(Point));
	node->childN = 0;

	// stop recursion if fewer than 100 points in x or y array
	if (nx < MINBOX || ny < MINBOX) return node;

	int ximed = (ximin + ximax) / 2;
	int yimed = (yimin + yimax) / 2;
	// don't split on same x or y val
	float curx = sc->xsort[ximed].x;
	float nextx = sc->xsort[ximed+1].x;
	while (ximed < ximax && curx == nextx) {
		ximed++;
		curx = sc->xsort[ximed].x;
		nextx = sc->xsort[ximed+1].x;
	}
	float cury = sc->ysort[yimed].y;
	float nexty = sc->ysort[yimed+1].y;
	while (yimed < yimax && cury == nexty) {
		yimed++;
		cury = sc->ysort[yimed].y;
		nexty = sc->ysort[yimed+1].y;
	}

	// build out children
	node->tr = buildNode(sc, ximed + 1, ximax, yimed + 1, yimax);
	node->tl = buildNode(sc, ximin,     ximed, yimed + 1, yimax);
	node->bl = buildNode(sc, ximin,     ximed, yimin,     yimed);
	node->br = buildNode(sc, ximed + 1, ximax, yimin,     yimed);

	return node;
}

void freeNode(TreeNode* node) {
	if (node->tr) freeNode(node->tr);
	if (node->tl) freeNode(node->tl);
	if (node->bl) freeNode(node->bl);
	if (node->br) freeNode(node->br);
	free(node->my20);
	free(node->child20);
	free(node->rect);
	free(node);
}

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* sc = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	sc->N = points_end - points_begin;
	sc->xsort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ysort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ranksort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xsort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ysort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ranksort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xsort, sc->N, sizeof(Point), xCompare);
	qsort(sc->ysort, sc->N, sizeof(Point), yCompare);
	qsort(sc->ranksort, sc->N, sizeof(Point), rankCompare);
	sc->root = buildNode(sc, 0, sc->N-1, 0, sc->N-1);
	sc->lbox = (Point*)calloc(20, sizeof(Point));
	sc->rbox = (Point*)calloc(20, sizeof(Point));
	sc->tbox = (Point*)calloc(20, sizeof(Point));
	sc->bbox = (Point*)calloc(20, sizeof(Point));

	printf("\nBuilt %d nodes\n", nodes);

	// FILE *f = fopen("points.csv", "w");
	// for (int i = 0; i < sc->N; i++) {
	// 	fprintf(f, "%d,%f,%f\n", sc->ranksort[i].rank, sc->ranksort[i].x, sc->ranksort[i].y);
	// }
	// fclose(f);

	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	return searchTree(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	free(context->xsort);
	free(context->ysort);
	free(context->ranksort);
	freeNode(context->root);
	free(context->lbox);
	free(context->rbox);
	free(context->tbox);
	free(context->bbox);
	return NULL;
}