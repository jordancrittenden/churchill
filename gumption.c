#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gumption.h"

#define DEBUG 1
#define RANKLIMIT 10000
#define BINARYLIMIT 2000
#define MAXDEPTH 5
#define NODERANKSIZE 240
#define LEAFRANKSIZE 1000
#define RANKMAX 100000000

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

inline bool isRectOverlap(Rect* r1, Rect* r2) {
	return r1->lx < r2->hx && r1->hx > r2->lx && r1->ly < r2->hy && r1->hy > r2->ly;
}

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

int32_t searchBinary(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int32_t n = 0;
	int xidxl = bsearch(sc->xsort, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	if ((nx < ny ? nx : ny) > RANKLIMIT) return findHitsS(&rect, sc->ranksort, sc->N, out_points, count);

	if (nx < ny) return findHitsUY(&rect, &sc->xsort[xidxl], nx, out_points, count);
	else return findHitsUX(&rect, &sc->ysort[yidxl], ny, out_points, count);
}

int32_t treeHits(GumpSearchContext* sc, const Rect rect, TreeNode* node, int count, Point* out_points) {
	printf("Checking node "); printRect(*node->rect);
	float w = rect.hx - rect.lx;
	float h = rect.hy - rect.ly;
	float nw = node->rect->hx - node->rect->lx;
	float nh = node->rect->hy - node->rect->ly;
	int hits = 0;
	bool leaf = node->children && !node->children[0];
	if (w < nw / 2 && h < nh < 2 && !leaf) {
		// printf("Target rect falls completely inside a child node\n");
		if (isRectInside((Rect*)&rect, node->children[1-1]->rect)) return treeHits(sc, rect, node->children[1-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[3-1]->rect)) return treeHits(sc, rect, node->children[3-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[7-1]->rect)) return treeHits(sc, rect, node->children[7-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[9-1]->rect)) return treeHits(sc, rect, node->children[9-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[5-1]->rect)) return treeHits(sc, rect, node->children[5-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[2-1]->rect)) return treeHits(sc, rect, node->children[2-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[4-1]->rect)) return treeHits(sc, rect, node->children[4-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[6-1]->rect)) return treeHits(sc, rect, node->children[6-1], count, out_points);
		if (isRectInside((Rect*)&rect, node->children[8-1]->rect)) return treeHits(sc, rect, node->children[8-1], count, out_points);
	} else if ((w > nw / 2 && h > nh / 2) || leaf) {
		// printf("Target rect is a least a quarter the size of this node rect, or this is a leaf\n");
		hits = findHitsS(&rect, node->ranksort, node->N, out_points, count);
	} else {
		// printf("Target rect spans multiple leaves, but is not a quarter the size of this node rect\n");
		int n1 = 0, n3 = 0, n7 = 0, n9 = 0;
		if (isRectOverlap((Rect*)&rect, node->children[1-1]->rect)) { n1 = treeHits(sc, rect, node->children[1-1], count, node->hits1); }
		if (isRectOverlap((Rect*)&rect, node->children[3-1]->rect)) { n3 = treeHits(sc, rect, node->children[3-1], count, node->hits3); }
		if (isRectOverlap((Rect*)&rect, node->children[7-1]->rect)) { n7 = treeHits(sc, rect, node->children[7-1], count, node->hits7); }
		if (isRectOverlap((Rect*)&rect, node->children[9-1]->rect)) { n9 = treeHits(sc, rect, node->children[9-1], count, node->hits9); }

		printf("Zipping up child results\n");
		// Merge child results
		int i1 = 0, i3 = 0, i7 = 0, i9 = 0;
		int rank1 = RANKMAX, rank3 = RANKMAX, rank7 = RANKMAX, rank9 = RANKMAX;
		while (hits < count) {
			if (i1 < n1) rank1 = node->hits1[i1].rank; else rank1 = RANKMAX;
			if (i3 < n3) rank3 = node->hits3[i3].rank; else rank3 = RANKMAX;
			if (i7 < n7) rank7 = node->hits7[i7].rank; else rank7 = RANKMAX;
			if (i9 < n9) rank9 = node->hits9[i9].rank; else rank9 = RANKMAX;

			if (rank1 == RANKMAX && rank3 == RANKMAX && rank7 == RANKMAX && rank9 == RANKMAX) break;

			     if (rank1 < rank9 && rank1 < rank7 && rank1 < rank3) { out_points[hits] = node->hits1[i1]; i1++; }
			else if (rank3 < rank9 && rank3 < rank7 && rank3 < rank1) { out_points[hits] = node->hits3[i3]; i3++; }
			else if (rank7 < rank9 && rank7 < rank1 && rank7 < rank3) { out_points[hits] = node->hits7[i7]; i7++; }
			else if (rank9 < rank7 && rank9 < rank1 && rank9 < rank3) { out_points[hits] = node->hits9[i9]; i9++; }

			hits++;
		}
	}

	if (hits < count) { if (node->children && node->children[0]) printf("NODE failure\n"); else printf("LEAF failure\n"); return -1; }	
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
	if ((nx < ny ? nx : ny) < BINARYLIMIT) {
		printf("Fallback on binary search\n");
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

TreeNode* buildNode(GumpSearchContext* sc, float xmin, float xmax, float ymin, float ymax, int depth, TreeNode* over1, TreeNode* over2, TreeNode* over3, TreeNode* over4, TreeNode* over6, TreeNode* over7, TreeNode* over8, TreeNode* over9) {
	// printf("Building node [%f,%f,%f,%f] at depth %d\n", xmin, xmax, ymin, ymax, depth);
	nodes++;
	TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
	node->rect = (Rect*)malloc(sizeof(Rect));
	node->rect->lx = xmin;
	node->rect->hx = xmax;
	node->rect->ly = ymin;
	node->rect->hy = ymax;
	node->hits1 = NULL;
	node->hits3 = NULL;
	node->hits7 = NULL;
	node->hits9 = NULL;
	node->ranksort = NULL;
	node->children = NULL;
	node->children = (TreeNode**)calloc(9, sizeof(TreeNode*));
	for (int i = 0; i < 9; i++) node->children[i] = NULL;

	// if this is not a leaf, build out children
	if (depth < MAXDEPTH) {
		node->ranksort = (Point*)calloc(NODERANKSIZE, sizeof(Point));
		node->N = searchBinary(sc, *node->rect, NODERANKSIZE, node->ranksort);

		float xmed = (xmax + xmin) / 2.0f;
		float ymed = (ymax + ymin) / 2.0f;
		float xq1 = (xmin + xmed) / 2.0f;
		float xq3 = (xmed + xmax) / 2.0f;
		float yq1 = (ymin + ymed) / 2.0f;
		float yq3 = (ymed + ymax) / 2.0f;
		TreeNode** c = node->children;
		c[1-1] = over1 ? over1 : buildNode(sc, xmin, xmed, ymin, ymed, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[3-1] = over3 ? over3 : buildNode(sc, xmed, xmax, ymin, ymed, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[7-1] = over7 ? over7 : buildNode(sc, xmin, xmed, ymed, ymax, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[9-1] = over9 ? over9 : buildNode(sc, xmed, xmax, ymed, ymax, depth+1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
		c[2-1] = over2 ? over2 : buildNode(sc, xq1,  xq3,  ymin, ymed, depth+1, c[1-1]->children[3-1], NULL, c[3-1]->children[1-1], c[1-1]->children[6-1], c[3-1]->children[4-1], c[1-1]->children[9-1], NULL, c[3-1]->children[7-1]);
		c[4-1] = over4 ? over4 : buildNode(sc, xmin, xmax, yq1,  yq3,  depth+1, c[1-1]->children[7-1], c[1-1]->children[8-1], c[1-1]->children[9-1], NULL, NULL, c[7-1]->children[1-1], c[7-1]->children[2-1], c[7-1]->children[3-1]);
		c[6-1] = over6 ? over6 : buildNode(sc, xmed, xmax, yq1,  yq3,  depth+1, c[3-1]->children[7-1], c[3-1]->children[8-1], c[3-1]->children[9-1], NULL, NULL, c[9-1]->children[1-1], c[9-1]->children[2-1], c[9-1]->children[3-1]);
		c[8-1] = over8 ? over8 : buildNode(sc, xq1,  xq3,  ymed, ymax, depth+1, c[7-1]->children[3-1], NULL, c[9-1]->children[1-1], c[7-1]->children[6-1], c[9-1]->children[4-1], c[7-1]->children[9-1], NULL, c[9-1]->children[7-1]);
		c[5-1] =                 buildNode(sc, xq1,  xq3,  yq1,  yq3,  depth+1, c[1-1]->children[9-1], c[2-1]->children[8-1], c[3-1]->children[7-1], c[4-1]->children[6-1], c[6-1]->children[4-1], c[7-1]->children[3-1], c[8-1]->children[2-1], c[9-1]->children[1-1]);

		node->hits1 = (Point*)calloc(20, sizeof(Point));
		node->hits3 = (Point*)calloc(20, sizeof(Point));
		node->hits7 = (Point*)calloc(20, sizeof(Point));
		node->hits9 = (Point*)calloc(20, sizeof(Point));
	} else {
		node->ranksort = (Point*)calloc(LEAFRANKSIZE, sizeof(Point));
		node->N = searchBinary(sc, *node->rect, LEAFRANKSIZE, node->ranksort);
	}

	return node;
}

void freeNode(TreeNode* node, bool free1, bool free2, bool free3, bool free4, bool free6, bool free7, bool free8, bool free9) {
	free(node->rect);
	free(node->ranksort);
	if (node->hits1) free(node->hits1);
	if (node->hits3) free(node->hits3);
	if (node->hits7) free(node->hits7);
	if (node->hits9) free(node->hits9);
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

	printf("Allocating memory and sorting shit\n");
	sc->xsort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ysort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ranksort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xsort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ysort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ranksort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xsort, sc->N, sizeof(Point), xcomp);
	qsort(sc->ysort, sc->N, sizeof(Point), ycomp);
	qsort(sc->ranksort, sc->N, sizeof(Point), rankcomp);

	float xmin = sc->xsort[1].x;
	float xmax = sc->xsort[sc->N-2].x;
	float ymin = sc->ysort[1].y;
	float ymax = sc->ysort[sc->N-2].y;

	printf("Building tree\n");
	sc->root = buildNode(sc, xmin, xmax, ymin, ymax, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

	// printf("\nBuilt %d ranges\n", ranges);
	free(sc->ranksort);
	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	printRect(rect);
	return searchTree(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->xsort) free(context->xsort);
	if (context->ysort) free(context->ysort);
	if (context->root)  freeNode(context->root, true, true, true, true, true, true, true, true);
	return NULL;
}