#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gumption.h"

#define DEBUG 1
#define SIMPLELIMIT 500
#define MAXDEPTH 5
#define NODERANKSIZE 1000

// DEBUGGING --------------------------------------------------------------------------------------

void printRect(Rect rect) {
	printf("[%f, %f, %f, %f]\n", rect.lx, rect.hx, rect.ly, rect.hy);
}

void printPoints(Point* points, int n) {
	for (int i = 0; i < n; i++) {
		printf("%d, %d, %f, %f\n", points[i].id, points[i].rank, points[i].x, points[i].y);
	}
}



// SORT ROUTINES ----------------------------------------------------------------------------------

inline int xcomp(const void* a, const void* b) {
	float diff = ((Point*)a)->x - ((Point*)b)->x;
	return diff > 0 ? 1 : diff < 0 ? -1 : 0;
}

inline int ycomp(const void* a, const void* b) {
	float diff = ((Point*)a)->y - ((Point*)b)->y;
	return diff > 0 ? 1 : diff < 0 ? -1 : 0;
}

inline int rankcomp(const void* a, const void* b) {
	return ((Point*)a)->rank - ((Point*)b)->rank;
}



// HELPER FUNCTIONS -------------------------------------------------------------------------------

int hitchecks = 0;
int totalhitchecks = 0;

inline bool isRectInside(Rect* r1, Rect* r2) {
	return r2->lx >= r1->lx && r2->ly >= r1->ly && r2->hx <= r1->hx && r2->hy <= r1->hy;
}

inline bool isHit(Rect* r, Point* p) {
	// hitchecks++;
	return p->x >= r->lx && p->x <= r->hx && p->y >= r->ly && p->y <= r->hy;
}

inline bool isHitX(Rect* r, Point* p) {
	// hitchecks++;
	return p->x >= r->lx && p->x <= r->hx;
}

inline bool isHitY(Rect* r, Point* p) {
	// hitchecks++;
	return p->y >= r->ly && p->y <= r->hy;
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

int32_t findHitsUX(const Rect* rect, Point* in, int n, Point* out, int count) {
	int i = 0;
	int hits = 0;

	// if fewer points in test buffer than allowed hits, use all hits
	if (n <= count) {
		for (int i = 0; i < n; i++) {
			Point p = in[i];
			if (p.x >= rect->lx && p.x <= rect->hx) {
				out[hits] = p;
				hits++;
			}
		}
		qsort(out, hits, sizeof(Point), rankcomp);
		return hits;
	}

	int j = 0;
	int max = -1;
	int maxloc = -1;

	// start by filling out with the first count hits from in
	while (i < n && hits < count) {
		Point p = in[i];
		if (p.x >= rect->lx && p.x <= rect->hx) {
			out[hits] = p;
			if (p.rank > max) {
				max = p.rank;
				maxloc = hits;
			}
			hits++;
		}
		i++;
	}

	// search through the remaining points in in
	while (i < n) {
		Point p = in[i];
		if (p.rank > max) {
			i++;
			continue;
		}

		if (p.x >= rect->lx && p.x <= rect->hx) {
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

	qsort(out, hits, sizeof(Point), rankcomp);
	return hits;
}

int32_t findHitsUY(const Rect* rect, Point* in, int n, Point* out, int count) {
	int i = 0;
	int hits = 0;

	// if fewer points in test buffer than allowed hits, use all hits
	if (n <= count) {
		for (int i = 0; i < n; i++) {
			Point p = in[i];
			if (p.y >= rect->ly && p.y <= rect->hy) {
				out[hits] = p;
				hits++;
			}
		}
		qsort(out, hits, sizeof(Point), rankcomp);
		return hits;
	}

	int j = 0;
	int max = -1;
	int maxloc = -1;

	// start by filling out with the first count hits from in
	while (i < n && hits < count) {
		Point p = in[i];
		if (p.y >= rect->ly && p.y <= rect->hy) {
			out[hits] = p;
			if (p.rank > max) {
				max = p.rank;
				maxloc = hits;
			}
			hits++;
		}
		i++;
	}

	// search through the remaining points in in
	while (i < n) {
		Point p = in[i];
		if (p.rank > max) {
			i++;
			continue;
		}

		if (p.y >= rect->ly && p.y <= rect->hy) {
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

	qsort(out, hits, sizeof(Point), rankcomp);
	return hits;
}

int32_t findHitsS(const Rect* rect, Point* in, int n, Point* out, int count) {
	int32_t k = 0;
	int i = 0;
	while (k < count && i < n) {
		Point p = in[i];
		if (p.x >= rect->lx && p.x <= rect->hx && p.y >= rect->ly && p.y <= rect->hy) {
			out[k] = p;
			k++;
		}
		i++;
	}

	return k;
}



// SEARCH IMPLEMENTATION --------------------------------------------------------------------------

int32_t treeHits(GumpSearchContext* sc, const Rect rect, TreeNode* node, int count, Point* out_points) {
	if (node->children && node->children[0]) {
		if (isRectInside((Rect*)&rect, node->children[1-1]->rect)) return treeHits(sc, rect, node->children[1-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[3-1]->rect)) return treeHits(sc, rect, node->children[3-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[7-1]->rect)) return treeHits(sc, rect, node->children[7-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[9-1]->rect)) return treeHits(sc, rect, node->children[9-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[5-1]->rect)) return treeHits(sc, rect, node->children[5-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[2-1]->rect)) return treeHits(sc, rect, node->children[2-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[4-1]->rect)) return treeHits(sc, rect, node->children[4-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[6-1]->rect)) return treeHits(sc, rect, node->children[6-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[8-1]->rect)) return treeHits(sc, rect, node->children[8-1], count, out_points);
	}

	int hits = findHitsS(&rect, node->ranksort, node->N, out_points, count);
	printf("Found %d hits in %d ranked points\n", hits, node->N);
	if (hits < count) { if (node->children && node->children[0]) printf("NODE\n"); else printf("LEAF\n"); return -1; }
	else printf("Worked\n");
	//if (hits < count) return -1;
	return hits;
}

int32_t searchTree(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bsearch(sc->xsort, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	// hitchecks = 0;

	// use simple binary if small range
	if ((nx < ny ? nx : ny) < SIMPLELIMIT) {
		if (nx < ny) return findHitsUY(&rect, &sc->xsort[xidxl], nx, out_points, count);
		else return findHitsUX(&rect, &sc->ysort[yidxl], ny, out_points, count);
	}

	int hits = treeHits(sc, rect, sc->root, count, out_points);

	if (hits == -1) {
		if (nx < ny) hits = findHitsUY(&rect, &sc->xsort[xidxl], nx, out_points, count);
		else hits = findHitsUX(&rect, &sc->ysort[yidxl], ny, out_points, count);
		// printf("Rect was %f,%f,%f,%f (%d,%d,%d,%d)\n",
		// 	rect.lx, rect.hx, rect.ly, rect.hy,
		// 	xidxl, xidxr, yidxl, yidxr
		// );
		// printf("%d, %d, %d, %d - %d checks (%d total)\n", xidxl, xidxr, yidxl, yidxr, hitchecks, totalhitchecks);
	}

	// totalhitchecks += hitchecks;

	return hits;
}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------

int nodes = 0;

TreeNode* buildNode(float xmin, float xmax, float ymin, float ymax, int depth, TreeNode* over1, TreeNode* over2, TreeNode* over3, TreeNode* over4, TreeNode* over6, TreeNode* over7, TreeNode* over8, TreeNode* over9) {
	// printf("Building node [%f,%f,%f,%f] at depth %d\n", xmin, xmax, ymin, ymax, depth);
	nodes++;
	TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
	node->rect = (Rect*)malloc(sizeof(Rect));
	node->rect->lx = xmin;
	node->rect->hx = xmax;
	node->rect->ly = ymin;
	node->rect->hy = ymax;
	node->ranksort = NULL;
	node->children = NULL;
	node->children = (TreeNode**)calloc(9, sizeof(TreeNode*));
	for (int i = 0; i < 9; i++) node->children[i] = NULL;

	node->N = 0;
	node->K = NODERANKSIZE;
	node->ranksort = (Point*)calloc(node->K, sizeof(Point));
	node->maxrank = -1;
	node->maxpos = 0;

	// if this is not a leaf, build out children
	if (depth < MAXDEPTH) {
		float xmed = (xmax + xmin) / 2.0f;
		float ymed = (ymax + ymin) / 2.0f;
		float xq1 = (xmin + xmed) / 2.0f;
		float xq3 = (xmed + xmax) / 2.0f;
		float yq1 = (ymin + ymed) / 2.0f;
		float yq3 = (ymed + ymax) / 2.0f;
		TreeNode** c = node->children;
		c[1-1] = over1 ? over1 : buildNode(xmin, xmed, ymin, ymed, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[3-1] = over3 ? over3 : buildNode(xmed, xmax, ymin, ymed, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[7-1] = over7 ? over7 : buildNode(xmin, xmed, ymed, ymax, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[9-1] = over9 ? over9 : buildNode(xmed, xmax, ymed, ymax, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[2-1] = over2 ? over2 : buildNode(xq1,  xq3,  ymin, ymed, depth+1, c[1-1]->children[3-1], NULL, c[3-1]->children[1-1], c[1-1]->children[6-1], c[3-1]->children[4-1], c[1-1]->children[9-1], NULL, c[3-1]->children[7-1]);
		c[4-1] = over4 ? over4 : buildNode(xmin, xmax, yq1,  yq3,  depth+1, c[1-1]->children[7-1], c[1-1]->children[8-1], c[1-1]->children[9-1], NULL, NULL, c[7-1]->children[1-1], c[7-1]->children[2-1], c[7-1]->children[3-1]);
		c[6-1] = over6 ? over6 : buildNode(xmed, xmax, yq1,  yq3,  depth+1, c[3-1]->children[7-1], c[3-1]->children[8-1], c[3-1]->children[9-1], NULL, NULL, c[9-1]->children[1-1], c[9-1]->children[2-1], c[9-1]->children[3-1]);
		c[8-1] = over8 ? over8 : buildNode(xq1,  xq3,  ymed, ymax, depth+1, c[7-1]->children[3-1], NULL, c[9-1]->children[1-1], c[7-1]->children[6-1], c[9-1]->children[4-1], c[7-1]->children[9-1], NULL, c[9-1]->children[7-1]);
		c[5-1] =                 buildNode(xq1,  xq3,  yq1,  yq3,  depth+1, c[1-1]->children[9-1], c[2-1]->children[8-1], c[3-1]->children[7-1], c[4-1]->children[6-1], c[6-1]->children[4-1], c[7-1]->children[3-1], c[8-1]->children[2-1], c[9-1]->children[1-1]);
	}

	return node;
}

void dropPoint(TreeNode* node, Point p, bool drop1, bool drop2, bool drop3, bool drop4, bool drop6, bool drop7, bool drop8, bool drop9) {
	// if this is not a leaf, drop into self and children
	if (node->children && node->children[0]) {
		if (isHit(node->rect, &p)) {
			if (node->N < node->K) {
				node->ranksort[node->N] = p;
				if (p.rank > node->maxrank) {
					node->maxrank = p.rank;
					node->maxpos = node->N;
				}
				node->N++;
			} else {
				// replace previous max with this point
				node->ranksort[node->maxpos] = p;

				// find new max
				node->maxrank = -1;
				node->maxpos = -1;
				for (int i = 0; i < node->N; i++) {
					if (node->ranksort[i].rank > node->maxrank) {
						node->maxrank = node->ranksort[i].rank;
						node->maxpos = i;
					}
				}
			}
		}

		bool drop5 = false;
		if (drop1 && isHit(node->children[1-1]->rect, &p)) {
			drop5 = true;
			dropPoint(node->children[1-1], p, true,  true,  true,  true,  true,  true,  true,  true);
			if (drop2) dropPoint(node->children[2-1], p, false, true,  false, false, false, false, true,  false);
			if (drop4) dropPoint(node->children[4-1], p, false, false, false, true,  true,  false, false, false);
		} else if (drop3 && isHit(node->children[3-1]->rect, &p)) {
			drop5 = true;
			dropPoint(node->children[3-1], p, true,  true,  true,  true,  true,  true,  true,  true);
			if (drop2) dropPoint(node->children[2-1], p, false, true,  false, false, false, false, true,  false);
			if (drop6) dropPoint(node->children[6-1], p, false, false, false, true,  true,  false, false, false);
		} else if (drop7 && isHit(node->children[7-1]->rect, &p)) {
			drop5 = true;
			dropPoint(node->children[7-1], p, true,  true,  true,  true,  true,  true,  true,  true);
			if (drop4) dropPoint(node->children[4-1], p, false, false, false, true,  true,  false, false, false);
			if (drop8) dropPoint(node->children[8-1], p, false, true,  false, false, false, false, true,  false);
		} else if (drop9 && isHit(node->children[9-1]->rect, &p)) {
			drop5 = true;
			dropPoint(node->children[9-1], p, true,  true,  true,  true,  true,  true,  true,  true);
			if (drop6) dropPoint(node->children[6-1], p, false, false, false, true,  true,  false, false, false);
			if (drop8) dropPoint(node->children[8-1], p, false, true,  false, false, false, false, true,  false);
		}
		if (drop5) dropPoint(node->children[5-1], p, false, false, false, false, false, false, false, false);
	} else {
		if (isHit(node->rect, &p)) {
			// double capacity if hit limit
			if (node->N == node->K) {
				Point* temp = (Point*)calloc(node->K*2, sizeof(Point));
				memcpy(temp, node->ranksort, node->K * sizeof(Point));
				free(node->ranksort);
				node->ranksort = temp;
				node->K = node->K*2;
			}

			node->ranksort[node->N] = p;
			node->N++;
		}
	}
}

void sortNode(TreeNode* node) {
	qsort(node->ranksort, node->N, sizeof(Point), rankcomp);
	if (node->children && node->children[0]) for (int i = 0; i < 9; i++) sortNode(node->children[i]);
}

void freeNode(TreeNode* node, bool free1, bool free2, bool free3, bool free4, bool free6, bool free7, bool free8, bool free9) {
	free(node->rect);
	free(node->ranksort);
	if (node->children) {
		if (node->children[1-1] && free1) freeNode(node->children[1-1], true,  true,  true,  true,  true,  true,  true,  true);
		if (node->children[2-1] && free2) freeNode(node->children[2-1], false, true,  false, false, false, false, true,  false);
		if (node->children[3-1] && free3) freeNode(node->children[3-1], true,  true,  true,  true,  true,  true,  true,  true);
		if (node->children[4-1] && free4) freeNode(node->children[4-1], false, false, false, true,  true,  false, false, false);
		if (node->children[5-1])          freeNode(node->children[5-1], false, false, false, false, false, false, false, false);
		if (node->children[6-1] && free6) freeNode(node->children[6-1], false, false, false, true,  true,  false, false, false);
		if (node->children[7-1] && free7) freeNode(node->children[7-1], true,  true,  true,  true,  true,  true,  true,  true);
		if (node->children[8-1] && free8) freeNode(node->children[8-1], false, true,  false, false, false, false, true,  false);
		if (node->children[9-1] && free9) freeNode(node->children[9-1], true,  true,  true,  true,  true,  true,  true,  true);
		free(node->children);
	}
	free(node);
}

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* sc = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	sc->N = points_end - points_begin;
	sc->xsort = NULL;
	sc->ysort = NULL;
	sc->root = NULL;
	if (sc->N == 0) return (SearchContext*)sc;

	sc->xsort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ysort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xsort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ysort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xsort, sc->N, sizeof(Point), xcomp);
	qsort(sc->ysort, sc->N, sizeof(Point), ycomp);

	float xmin = sc->xsort[1].x;
	float xmax = sc->xsort[sc->N-2].x;
	float ymin = sc->ysort[1].y;
	float ymax = sc->ysort[sc->N-2].y;

	printf("Found data bounds [%f,%f,%f,%f]\n", xmin, xmax, ymin, ymax);

	printf("Building tree\n");
	sc->root = buildNode(xmin, xmax, ymin, ymax, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
	printf("Dropping points\n");
	for (int i = 0; i < sc->N; i++) {
		if (i % 500000 == 0) printf("Dropped %d points\n", i);
		dropPoint(sc->root, sc->xsort[i], true, true, true, true, true, true, true, true);
	}
	printf("Sorting tree\n");
	sortNode(sc->root);

	// printf("\nBuilt %d ranges\n", ranges);
	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	printf("\n"); printRect(rect);
	return searchTree(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->xsort) free(context->xsort);
	if (context->ysort) free(context->ysort);
	if (context->root) freeNode(context->root, true, true, true, true, true, true, true, true);
	return NULL;
}