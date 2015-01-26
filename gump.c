#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "gump.h"

#define DEBUG 0
#define WRITEFILES 1
#define SIMPLELIMIT 1000
#define MAXDEPTH 8 //39062.5
#define BASELIMIT 10000
#define DEPTHFACTOR 1000

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

inline float pow(float x, float p) {
	float y = x;
	for (int i = 1; i < p; i++) y *= x;
	return y;
}

inline bool isHit(Rect* r, Point* p) {
	return p->x >= r->lx && p->x <= r->hx && p->y >= r->ly && p->y <= r->hy;
}

inline bool isHitX(Rect* r, Point* p) {
	return p->x >= r->lx && p->x <= r->hx;
}

inline bool isHitY(Rect* r, Point* p) {
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

int32_t findHitsU(Rect* rect, Point* in, int n, Point* out, int count, bool (*hitcheck)(Rect* r, Point* p)) {
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
		qsort(out, hits, sizeof(Point), rankcomp);
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

	qsort(out, hits, sizeof(Point), rankcomp);
	return hits;
}

int32_t findHitsS(Rect* rect, Point* in, int n, Point* out, int count) {
	int32_t k = 0;
	int i = 0;
	while (k < count && i < n) {
		Point p = in[i];
		if (isHit(rect, &p)) {
			out[k] = p;
			k++;
		}
		i++;
	}

	return k;
}



// SEARCH IMPLEMENTATIONS -------------------------------------------------------------------------

// baseline search - search full list of points, sorted by rank increasing
int32_t searchBaseline(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	return findHitsS((Rect*)&rect, sc->ranksort, sc->N, out_points, count);
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

	if ((nx < ny ? nx : ny) > BASELIMIT) return searchBaseline(sc, rect, count, out_points);

	if (nx < ny) return findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
	else return findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
}


// ranked binary - narrow search to points in x range, y range, and check smaller set using range data structure
int32_t rangeHits(GumpSearchContext* sc, const Rect rect, Range* range, int left, int right, int count, Point* out_points, int depth) {
	if (range->left  && range->left->l  <= left && range->left->r  >= right) return rangeHits(sc, rect, range->left,  left, right, count, out_points, depth + 1);
	if (range->right && range->right->l <= left && range->right->r >= right) return rangeHits(sc, rect, range->right, left, right, count, out_points, depth + 1);
	if (range->mid   && range->mid->l   <= left && range->mid->r   >= right) return rangeHits(sc, rect, range->mid,   left, right, count, out_points, depth + 1);

	int len = pow(2, MAXDEPTH - depth) * DEPTHFACTOR;
	int hits = findHitsS((Rect*)&rect, range->ranksort, len, out_points, count);
	if (hits < count) return -depth;
	return hits;
}

int32_t searchRange(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bsearch(sc->xsort, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	int hits = 0;

	if ((nx < ny ? nx : ny) < SIMPLELIMIT) {
		if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
		else hits = findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
	} else {
		if (nx < ny) hits = rangeHits(sc, rect, sc->xroot, xidxl, xidxr, count, out_points, 1);
		else hits = rangeHits(sc, rect, sc->yroot, yidxl, yidxr, count, out_points, 1);

		if (hits < 0) {
			if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
			else hits = findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
		}
	}

	return hits;
}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------

int ranges = 0;

float selx(Point* p) { return p->x; }
float sely(Point* p) { return p->y; }

Range* buildRange(GumpSearchContext* sc, int l, int r, float (*sel)(Point* p), bool xOrY, Range* lover, Range* rover, int depth) {
	ranges++;
	Range* range = (Range*)malloc(sizeof(Range));
	range->l = l;
	range->r = r;
	range->left = NULL;
	range->right = NULL;
	range->mid = NULL;
	range->ranksort = NULL;

	int n = r - l + 1;
	int len = pow(2, MAXDEPTH - depth) * DEPTHFACTOR;

	range->ranksort = (Point*)calloc(len, sizeof(Point));
	const Rect rect = {
		.lx = xOrY ? sc->xsort[l].x : sc->xsort[0].x,
		.ly = xOrY ? sc->ysort[0].y : sc->ysort[l].y,
		.hx = xOrY ? sc->xsort[r].x : sc->xsort[sc->N-1].x,
		.hy = xOrY ? sc->ysort[sc->N-1].y : sc->ysort[r].y
	};
	searchBinary(sc, rect, len, range->ranksort);

	// is this a leaf
	if (depth == MAXDEPTH) return range;

	// don't split on same val
	Point* sort = xOrY ? sc->xsort : sc->ysort;

	int med = (l + r) / 2;
	float cur = sel(&sort[med]);
	float next = sel(&sort[med+1]);
	while (cur == next) {
		med++;
		cur = sel(&sort[med]);
		next = sel(&sort[med+1]);
	}

	int q1 = (l + med) / 2;
	cur = sel(&sort[q1]);
	next = sel(&sort[q1+1]);
	while (cur == next) {
		q1++;
		cur = sel(&sort[q1]);
		next = sel(&sort[q1+1]);
	}

	int q3 = (med + r) / 2;
	cur = sel(&sort[med]);
	next = sel(&sort[med+1]);
	while (cur == next) {
		q3++;
		cur = sel(&sort[q3]);
		next = sel(&sort[q3+1]);
	}

	range->left  = lover ? lover : buildRange(sc, l, med, sel, xOrY, NULL, NULL, depth+1);
	range->right = rover ? rover : buildRange(sc, med, r, sel, xOrY, NULL, NULL, depth+1);
	range->mid   = buildRange(sc, q1, q3, sel, xOrY, range->left->right, range->right->left, depth+1);

	return range;
}

void freeRange(Range* range, bool left, bool right) {
	if (left  && range->left)     freeRange(range->left, true, true);
	if (right && range->right)    freeRange(range->right, true, true);
	if (range->mid)      freeRange(range->mid, false, false);
	if (range->ranksort) free(range->ranksort);
	free(range);
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
	qsort(sc->xsort, sc->N, sizeof(Point), xcomp);
	qsort(sc->ysort, sc->N, sizeof(Point), ycomp);
	qsort(sc->ranksort, sc->N, sizeof(Point), rankcomp);

	sc->xroot = buildRange(sc, 0, sc->N-1, selx, true, NULL, NULL, 1);
	sc->yroot = buildRange(sc, 0, sc->N-1, sely, false, NULL, NULL, 1);

	free(sc->ranksort);

	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	return searchRange(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	free(context->xsort);
	free(context->ysort);
	freeRange(context->xroot, true, true);
	freeRange(context->yroot, true, true);
	return NULL;
}