#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gumption.h"

#define DEBUG 1
#define SIMPLELIMIT 500
#define MAXDEPTH 4

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
	if (node->children) {
		for (int i = 0; i < 9; i++) {
			TreeNode child = node->children[i];
			if (isRectInside((Rect*)&rect, child.rect)) return treeHits(sc, rect, &child, count, out_points);
		}
	}

	int hits = findHitsS(&rect, node->ranksort, node->N, out_points, count);
	if (hits < count) { if (node->children) printf("NODE\n"); else printf("LEAF\n"); return -1; }
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

void buildNode(TreeNode* node, float xmin, float xmax, float ymin, float ymax, int depth) {
	// printf("Building node [%f,%f,%f,%f] at depth %d\n", xmin, xmax, ymin, ymax, depth);
	nodes++;
	node->rect = (Rect*)malloc(sizeof(Rect));
	node->rect->lx = xmin;
	node->rect->hx = xmax;
	node->rect->ly = ymin;
	node->rect->ly = ymax;
	node->ranksort = NULL;
	node->children = NULL;

	node->N = 0;
	node->K = 1000;
	node->ranksort = (Point*)calloc(node->K, sizeof(Point));
	node->maxrank = -1;
	node->maxpos = 0;

	// if this is not a leaf, build out children
	if (depth < MAXDEPTH) {
		node->children = (TreeNode*)calloc(9, sizeof(TreeNode));
		float cxmin = 0.0f, cxmax = 0.0f;
		float cymin = 0.0f, cymax = 0.0f;
		float dx = xmax - xmin;
		float dy = ymax - ymin;
		for (int r = 0; r < 3; r++) {
			cxmin = xmin + dx * r / 4;
			cxmax = xmax - dx * (2 - r) / 4;
			for (int c = 0; c < 3; c++) {
				cymin = ymin + dy * c / 4;
				cymax = ymax - dy * (2 - c) / 4;
				buildNode(&(node->children[r*3 + c]), cxmin, cxmax, cymin, cymax, depth+1);
			}
		}
	}
}

void dropPoint(TreeNode* node, Point p) {
	// if this is not a leaf, drop into self and children
	if (node->children) {
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

		for (int i = 0; i < 9; i++) {
			if (isHit(node->children[i].rect, &p)) {
				dropPoint(&(node->children[i]), p);
			}
		}
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
	if (node->children) for (int i = 0; i < 9; i++) sortNode(&node->children[i]);
}

void freeNode(TreeNode* node) {
	free(node->ranksort);
	if (node->children) for (int i = 0; i < 9; i++) freeNode(&node->children[i]);
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

	// printf("Found data bounds [%f,%f,%f,%f]\n", xmin, xmax, ymin, ymax);

	sc->root = (TreeNode*)malloc(sizeof(TreeNode));
	printf("Building tree\n");
	buildNode(sc->root, xmin, xmax, ymin, ymax, 0);
	printf("Dropping points\n");
	for (int i = 0; i < sc->N; i++) {
		if (i % 100000 == 0) printf("Dropped %d points\n", i);
		dropPoint(sc->root, sc->xsort[i]);
	}
	printf("Sorting tree\n");
	sortNode(sc->root);

	// printf("\nBuilt %d ranges\n", ranges);
	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	return searchTree(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->xsort) free(context->xsort);
	if (context->ysort) free(context->ysort);
	if (context->root) freeNode(context->root);
	return NULL;
}