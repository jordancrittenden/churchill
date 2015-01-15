#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gump.h"

#define DEBUG 0

// DEBUGGING --------------------------------------------------------------------------------------

void printContext(GumpSearchContext* context) {
	int i = 0;
	printf("\n%d Points\n", context->N);
	printf("xSort:\n");
	for (i = 0; i < context->N; i++) {
		printf("%d, %d, %f, %f\n", context->xSort[i].id, context->xSort[i].rank, context->xSort[i].x, context->xSort[i].y);
	}
	printf("ySort:\n");
	for (i = 0; i < context->N; i++) {
		printf("%d, %d, %f, %f\n", context->ySort[i].id, context->ySort[i].rank, context->ySort[i].x, context->ySort[i].y);
	}
	printf("rankSort:\n");
	for (i = 0; i < context->N; i++) {
		printf("%d, %d, %f, %f\n", context->rankSort[i].id, context->rankSort[i].rank, context->rankSort[i].x, context->rankSort[i].y);
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
int32_t searchBaseline(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	// FILE *f = fopen("rects.csv", "a");
	// fprintf(f, "%f,%f,%f,%f\n", rect.lx, rect.hx, rect.ly, rect.hy);
	// fclose(f);

	GumpSearchContext* context = (GumpSearchContext*)sc;
	int32_t n = 0;
	int i = 0;
	while (n < count && i < context->N) {
		Point p = context->rankSort[i];
		if (isHit(&rect, &p)) {
			out_points[n] = p;
			n++;
		}
		i++;
	}

	return n;
}


// binary search - narrow search to points in x range, y range, and check smaller set
int32_t searchBinary(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	int32_t n = 0;
	int xidxl = bsearch(context->xSort, true, true, rect.lx, 0, context->N);
	int xidxr = bsearch(context->xSort, true, false, rect.hx, 0, context->N);
	int yidxl = bsearch(context->ySort, false, true, rect.ly, 0, context->N);
	int yidxr = bsearch(context->ySort, false, false, rect.hy, 0, context->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	float ratio = (float)(nx < ny ? nx : ny) / (float)context->N;
	if (ratio > .01f) return searchBaseline(sc, rect, count, out_points);

	if (nx < ny) return findHits(&rect, &context->xSort[xidxl], nx, out_points, count, isHitY);
	else return findHits(&rect, &context->ySort[yidxl], ny, out_points, count, isHitX);
}


// tree search - build quadtree and narrow use precomputed solutions as starting point
int32_t searchTree(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {

}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------

TreeNode* buildNode(Point* xSort, int ximin, int ximax, Point* ySort, int yimin, int yimax) {
	TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
	// compute top 20 in this region

	// build out children
	int nx = ximax - ximin + 1;
	int ny = yimax - yimin + 1;
	if (nx < 100 || ny < 100) return node;

	int ximed = (ximin + ximax) / 2;
	int yimed = (yimin + yimax) / 2;
	while (ximed < ximax && xSort[ximed] == xSort[ximed+1]) ximed++; // don't break on same x val
	while (yimed < yimax && ySort[yimed] == xSort[yimed+1]) yimed++; // don't break on same y val

	node->tr = buildNode(xSort, ximed + 1, xmax, ySort, yimed + 1, yimax);
	node->tl = buildNode(xSort, ximin,    ximed, ySort, yimed + 1, yimax);
	node->bl = buildNode(xSort, ximin,    ximed, ySort, yimin,     yimed);
	node->br = buildNode(xSort, ximed + 1, xmax, ySort, yimin,     yimed);
}

void freeNode(TreeNode* node) {
	if (node->tr) freeNode(node->tr);
	if (node->tl) freeNode(node->tl);
	if (node->bl) freeNode(node->bl);
	if (node->br) freeNode(node->br);
	if (node->tr) free(node->tr);
	if (node->tl) free(node->tl);
	if (node->bl) free(node->bl);
	if (node->br) free(node->br);
	free(node->top20);
}

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* context = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	context->N = points_end - points_begin;
	context->xSort = (Point*)calloc(context->N, sizeof(Point));
	context->ySort = (Point*)calloc(context->N, sizeof(Point));
	context->rankSort = (Point*)calloc(context->N, sizeof(Point));
	memcpy(context->xSort, points_begin, context->N * sizeof(Point));
	memcpy(context->ySort, points_begin, context->N * sizeof(Point));
	memcpy(context->rankSort, points_begin, context->N * sizeof(Point));
	qsort(context->xSort, context->N, sizeof(Point), xCompare);
	qsort(context->ySort, context->N, sizeof(Point), yCompare);
	qsort(context->rankSort, context->N, sizeof(Point), rankCompare);
	return (SearchContext*)context;

	// FILE *f = fopen("points.csv", "w");
	// for (int i = 0; i < context->N; i++) {
	// 	fprintf(f, "%d,%f,%f\n", context->rankSort[i].rank, context->rankSort[i].x, context->rankSort[i].y);
	// }
	// fclose(f);
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	return searchBinary(sc, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	free(context->xSort);
	free(context->ySort);
	free(context->rankSort);
	freeNode(context->root);
	return NULL;
}