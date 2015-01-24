#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gumption.h"

#define DEBUG 0

#define DIVS 12
#define BIGBLOCK 1500
#define SMALLBLOCK 5000
#define AREALIMIT 10.0f

#define BLOCKSIZE 1000
#define RANKMAX 100000000

#define MINRANGE 5000
#define NODEPOINTS 1000
#define LEAFPOINTS 100

// DEBUGGING --------------------------------------------------------------------------------------

void printRect(Rect rect) {
	printf("[%f, %f, %f, %f]\n", rect.lx, rect.hx, rect.ly, rect.hy);
}

void printPoints(Point* points, int n) {
	for (int i = 0; i < n; i++) {
		printf("%d, %f, %f\n", points[i].rank, points[i].x, points[i].y);
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

inline float rectArea(Rect* rect) {
	return (rect->hx - rect->lx) * (rect->hy - rect->ly);
}

inline bool isHit(Rect* r, Point* p) {
	hitchecks++;
	return p->x >= r->lx && p->x <= r->hx && p->y >= r->ly && p->y <= r->hy;
}

inline bool isHitX(Rect* r, Point* p) {
	hitchecks++;
	return p->x >= r->lx && p->x <= r->hx;
}

inline bool isHitY(Rect* r, Point* p) {
	hitchecks++;
	return p->y >= r->ly && p->y <= r->hy;
}

int bsearch(float* p, bool minOrMax, float v, int imin, int imax) {
	while (imax >= imin) {
		int imid = (imin + imax) / 2;
		float val = p[imid];
		if (val == v) {
			if (minOrMax) {
				while (imid > imin && p[imid-1] == v) imid--;
				return imid;
			} else {
				while (imid < imax && p[imid+1] == v) imid++;
				return imid;
			}
		}
		else if (val < v) imin = imid + 1;
		else imax = imid - 1;
	}
	return minOrMax ? imin : imax;
}

int bsearchp(Point p[], bool xOrY, bool minOrMax, float v, int imin, int imax) {
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

int32_t findHitsB(GumpSearchContext* sc, Rect* rect, Point* in, int idxl, int idxr, Point* out, int count) {
	int32_t k = 0;

	int lblockstart = idxl - (idxl % BLOCKSIZE);
	int rblockstart = idxr - (idxr % BLOCKSIZE);
	int nblocks = (rblockstart - lblockstart) / BLOCKSIZE + 1;

	for (int i = 0; i < nblocks; i++) {
		sc->blocki[i] = lblockstart + i*BLOCKSIZE;
	}

	int minrank = RANKMAX;
	int minblock = 0;
	int fin = 0;
	while (k < count) {
		if (k == 0) {
			// For first hit, bump all indexes to a hit
			for (int i = 0; i < nblocks; i++) {
				while (!isHit(rect, &in[sc->blocki[i]]) && sc->blocki[i] < lblockstart + (i+1)*BLOCKSIZE) sc->blocki[i]++;
				sc->blockr[i] = in[sc->blocki[i]].rank;
			}
		} else {
			// afterward, only bump last hit block to another hit
			do { sc->blocki[minblock]++; } while (!isHit(rect, &in[sc->blocki[minblock]]) && sc->blocki[minblock] < lblockstart + (minblock+1)*BLOCKSIZE);
			sc->blockr[minblock] = in[sc->blocki[minblock]].rank;
		}

		minrank = RANKMAX;
		fin = 0;
		for (int i = 0; i < nblocks; i++) {
			if (sc->blocki[i] >= lblockstart + (i+1)*BLOCKSIZE) { fin++; continue; }
			if (sc->blockr[i] < minrank) {
				minrank = sc->blockr[i];
				minblock = i;
			}
		}

		// If we've hit the end of all blocks, exit
		if (fin == nblocks) break;

		out[k] = in[sc->blocki[minblock]];
		k++;
	}

	return k;
}



// SEARCH IMPLEMENTATION --------------------------------------------------------------------------

int32_t searchBinary(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bsearchp(sc->xrank, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearchp(sc->xrank, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearchp(sc->yrank, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearchp(sc->yrank, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	if (nx < ny) return findHitsU((Rect*)&rect, &sc->xrank[xidxl], nx, out_points, count, isHitY);
	else return findHitsU((Rect*)&rect, &sc->yrank[yidxl], ny, out_points, count, isHitX);
}

int32_t rangeHits(GumpSearchContext* sc, const Rect rect, Range* range, int left, int right, int count, Point* out_points) {
	if (range->left  && range->left->l  <= left && range->left->r  >= right) return rangeHits(sc, rect, range->left,  left, right, count, out_points);
	if (range->right && range->right->l <= left && range->right->r >= right) return rangeHits(sc, rect, range->right, left, right, count, out_points);
	if (range->mid   && range->mid->l   <= left && range->mid->r   >= right) return rangeHits(sc, rect, range->mid,   left, right, count, out_points);

	int len = range->mid ? NODEPOINTS : LEAFPOINTS;
	int hits = findHitsS((Rect*)&rect, range->ranksort, len, out_points, count);
	if (hits < count) { if (range->mid) printf("NODE - "); else printf("LEAF - "); return -1; }
	if (hits < count) return -1;
	return hits;
}

int32_t searchGrid(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bsearchp(sc->xrank, true, true, rect.lx, 0, sc->N);
	int xidxr = bsearchp(sc->xrank, true, false, rect.hx, 0, sc->N);
	int yidxl = bsearchp(sc->yrank, false, true, rect.ly, 0, sc->N);
	int yidxr = bsearchp(sc->yrank, false, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	hitchecks = 0;

	sc->trim->lx = rect.lx; sc->trim->hx = rect.hx;
	sc->trim->ly = rect.ly; sc->trim->hy = rect.hy;
	if (sc->trim->lx < sc->bounds->lx) sc->trim->lx = sc->bounds->lx;
	if (sc->trim->hx > sc->bounds->hx) sc->trim->hx = sc->bounds->hx;
	if (sc->trim->ly < sc->bounds->ly) sc->trim->ly = sc->bounds->ly;
	if (sc->trim->hy > sc->bounds->hy) sc->trim->hy = sc->bounds->hy;

	float xmini = (sc->trim->lx - sc->bounds->lx) / sc->dx;
	float ymini = (sc->trim->ly - sc->bounds->ly) / sc->dy;
	float xmaxi = (sc->trim->hx - sc->bounds->lx) / sc->dx;
	float ymaxi = (sc->trim->hy - sc->bounds->ly) / sc->dy;

	int i = floor(xmini);
	int j = floor(ymini);
	int w = ceil(xmaxi) - i - 1;
	int h = ceil(ymaxi) - j - 1;

	Rect* searchr = &sc->rect[i][j][w][h];
	float rw = searchr->hx - searchr->lx;
	float rh = searchr->hy - searchr->ly;
	float rarea = rectArea(searchr);
	float qw = sc->trim->hx - sc->trim->lx;
	float qh = sc->trim->hy - sc->trim->ly;
	float qarea = rectArea(sc->trim);
	int rhitlen = sc->rlen[i][j][w][h];

	int hits = 0;

	int bigside   = (nx > ny ? nx : ny);
	int smallside = (nx < ny ? nx : ny);

	// use simple binary if probability is we'll need to check fewer points
	if (smallside < 2 * count * rarea / qarea) {
		if (DEBUG) printf("Small search area - binary search : ");
		if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xrank[xidxl], nx, out_points, count, isHitY);
		else hits = findHitsU((Rect*)&rect, &sc->yrank[yidxl], ny, out_points, count, isHitX);
	}
	// use range search for tall skinny or short fat rects
	else if (bigside > 20 * smallside) {
		if (DEBUG) printf("Disproportionate - range search   : ");
		if (nx < ny) hits = rangeHits(sc, rect, sc->xroot, xidxl, xidxr, count, out_points);
		else hits = rangeHits(sc, rect, sc->yroot, yidxl, yidxr, count, out_points);
	}
	// use simple ranksort search for big rects
	else if (rhitlen == -1) {
		if (DEBUG) printf("Big search area - ranksort search : ");
		hits = findHitsS(sc->trim, sc->ranksort, sc->N, out_points, count);
	}
	// use grid search for everything else
	else {
		if (DEBUG) printf("Medium search area - grid search  : ");
		hits = findHitsS(sc->trim, sc->grid[i][j][w][h], sc->rlen[i][j][w][h], out_points, count);
		if (hits < 20 && sc->rlen[i][j][w][h] > 20) {
			if (w == 0 || h == 0) printf("SMALL - "); else printf("BIG - ");
			hits = -1;
		}
	}

	// if a search method failed, use backup
	if (hits == -1) {
		printf("Found %d hits - falling back on binary search - \n", hits);
		if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xrank[xidxl], nx, out_points, count, isHitY);
		else hits = findHitsU((Rect*)&rect, &sc->yrank[yidxl], ny, out_points, count, isHitX);
	}

	totalhitchecks += hitchecks;
	if (DEBUG) printf("%6d checks : %7d total\n", hitchecks, totalhitchecks);
	// FILE *f = fopen("rects.csv", "a");
	// fprintf(f, "%f,%f,%f,%f,%d\n", rect.lx, rect.hx, rect.ly, rect.hy, hitchecks);
	// fclose(f);

	return hits;
}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------

float selx(Point* p) { return p->x; }
float sely(Point* p) { return p->y; }

Range* buildRange(GumpSearchContext* sc, int l, int r, float (*sel)(Point* p), bool xOrY, Range* lover, Range* rover) {
	Range* range = (Range*)malloc(sizeof(Range));
	range->l = l;
	range->r = r;
	range->left = NULL;
	range->right = NULL;
	range->mid = NULL;
	range->ranksort = NULL;

	int n = r - l + 1;
	int len = n < MINRANGE ? LEAFPOINTS : NODEPOINTS;

	range->ranksort = (Point*)calloc(len, sizeof(Point));
	const Rect rect = {
		.lx = xOrY ? sc->xrank[l].x : sc->xrank[0].x,
		.ly = xOrY ? sc->yrank[0].y : sc->yrank[l].y,
		.hx = xOrY ? sc->xrank[r].x : sc->xrank[sc->N-1].x,
		.hy = xOrY ? sc->yrank[sc->N-1].y : sc->yrank[r].y
	};
	searchBinary(sc, rect, len, range->ranksort);

	// is this a leaf
	if (n < MINRANGE) return range;

	// don't split on same val
	Point* sort = xOrY ? sc->xrank : sc->yrank;

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

	range->left  = lover ? lover : buildRange(sc, l, med, sel, xOrY, NULL, NULL);
	range->right = rover ? rover : buildRange(sc, med, r, sel, xOrY, NULL, NULL);
	range->mid   = buildRange(sc, q1, q3, sel, xOrY, range->left->right, range->right->left);

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
	if (sc->N == 0) return (SearchContext*)sc;

	printf("Allocating memory and sorting shit\n");
	sc->xrank = (Point*)calloc(sc->N, sizeof(Point));
	sc->yrank = (Point*)calloc(sc->N, sizeof(Point));
	// sc->xsort = (float*)calloc(sc->N, sizeof(float));
	// sc->ysort = (float*)calloc(sc->N, sizeof(float));
	sc->ranksort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xrank, points_begin, sc->N * sizeof(Point));
	memcpy(sc->yrank, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ranksort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xrank, sc->N, sizeof(Point), xcomp);
	qsort(sc->yrank, sc->N, sizeof(Point), ycomp);
	qsort(sc->ranksort, sc->N, sizeof(Point), rankcomp);

	// for (int i = 0; i < sc->N; i++) {
	// 	sc->xsort[i] = sc->xrank[i].x;
	// 	sc->ysort[i] = sc->yrank[i].y;
	// }

	// for (int i = 0; i < sc->N; i += BLOCKSIZE) {
	// 	qsort(&sc->xrank[i], BLOCKSIZE, sizeof(Point), rankcomp);
	// 	qsort(&sc->yrank[i], BLOCKSIZE, sizeof(Point), rankcomp);
	// }

	sc->trim = (Rect*)malloc(sizeof(Rect));
	sc->bounds = (Rect*)malloc(sizeof(Rect));

	sc->blocki = (int*)calloc(100, sizeof(int));
	sc->blockr = (int*)calloc(100, sizeof(int));

	sc->bounds->lx = sc->xrank[1].x;
	sc->bounds->hx = sc->xrank[sc->N-2].x;
	sc->bounds->ly = sc->yrank[1].y;
	sc->bounds->hy = sc->yrank[sc->N-2].y;
	float area = rectArea(sc->bounds);

	float d = DIVS;
	sc->dx = (sc->bounds->hx - sc->bounds->lx) / d;
	sc->dy = (sc->bounds->hy - sc->bounds->ly) / d;

	sc->grid = (Point*****)calloc(d, sizeof(Point****));
	sc->rlen = (int****)calloc(d, sizeof(int***));
	sc->rect = (Rect****)calloc(d, sizeof(Rect***));
	for (int i = 0; i < d; i++) {
		float lx = sc->bounds->lx + (float)i * sc->dx;
		sc->grid[i] = (Point****)calloc(d, sizeof(Point***));
		sc->rlen[i] = (int***)calloc(d, sizeof(int**));
		sc->rect[i] = (Rect***)calloc(d, sizeof(Rect**));
		for (int j = 0; j < d; j++) {
			float ly = sc->bounds->ly + (float)j * sc->dy;
			sc->grid[i][j] = (Point***)calloc(d, sizeof(Point**));
			sc->rlen[i][j] = (int**)calloc(d, sizeof(int*));
			sc->rect[i][j] = (Rect**)calloc(d, sizeof(Rect*));
			for (int w = 0; w < d - i; w++) {
				float hx = sc->bounds->lx + (float)(i + w + 1) * sc->dx;
				sc->grid[i][j][w] = (Point**)calloc(d-j, sizeof(Point*));
				sc->rlen[i][j][w] = (int*)calloc(d-j, sizeof(int));
				sc->rect[i][j][w] = (Rect*)calloc(d-j, sizeof(Rect));
				for (int h = 0; h < d - j; h++) {
					float hy = sc->bounds->ly + (float)(j + h + 1) * sc->dy;
					sc->rect[i][j][w][h].lx = lx;
					sc->rect[i][j][w][h].ly = ly;
					sc->rect[i][j][w][h].hx = hx;
					sc->rect[i][j][w][h].hy = hy;

					if (area / rectArea(&sc->rect[i][j][w][h]) < AREALIMIT) {
						sc->rlen[i][j][w][h] = -1;
						continue;
					}

					int size = (w == 0 || h == 0) ? SMALLBLOCK : BIGBLOCK;
					sc->grid[i][j][w][h] = (Point*)calloc(size, sizeof(Point));
					sc->rlen[i][j][w][h] = findHitsS(&sc->rect[i][j][w][h], sc->ranksort, sc->N, sc->grid[i][j][w][h], size);
				}
			}
		}
	}

	sc->xroot = buildRange(sc, 0, sc->N-1, selx, true, NULL, NULL);
	sc->yroot = buildRange(sc, 0, sc->N-1, sely, false, NULL, NULL);

	// FILE *f = fopen("points.csv", "w");
	// for (int i = 0; i < sc->N; i++) {
	// 	fprintf(f, "%d,%f,%f\n", sc->ranksort[i].rank, sc->ranksort[i].x, sc->ranksort[i].y);
	// }
	// fclose(f);

	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	return searchGrid(context, rect, count, out_points);
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return NULL;

	// free(context->xsort);
	// free(context->ysort);
	free(context->xrank);
	free(context->yrank);
	free(context->blocki);
	free(context->blockr);
	free(context->trim);
	free(context->ranksort);
	for (int i = 0; i < DIVS-1; i++) {
		for (int j = 0; j < DIVS-1; j++) {
			for (int w = 1; w < DIVS - i; w++) {
				for (int h = 1; h < DIVS - j; h++) {
					free(context->grid[i][j][w][h]);
				}
				free(context->grid[i][j][w]);
				free(context->rlen[i][j][w]);
				free(context->rect[i][j][w]);
			}
			free(context->grid[i][j]);
			free(context->rlen[i][j]);
			free(context->rect[i][j]);
		}
		free(context->grid[i]);
		free(context->rlen[i]);
		free(context->rect[i]);
	}
	freeRange(context->xroot, true, true);
	freeRange(context->yroot, true, true);
	return NULL;
}