#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gumptionaire.h"

#define DEBUG 1
#define WRITEFILES 1

// rank search parameters
#define BASELIMIT 10000

// binary search parameters
#define BINARYLIMIT 1000

// range search parameters
#define MAXDEPTH 8 //39062.5
#define DEPTHFACTOR 1000

// grid search parameters
#define DIVS 50
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

int32_t findHitsB(GumpSearchContext* sc, Rect* rect, int bx, int by, int w, int h, Point* out, int count) {
	int32_t k = 0;

	printf("shit1 ");
	for (int i = 0; i < w; i++) {
		for (int j = 0; j < h; j++) {
			int b = i*w + j;
			sc->blocki[b] = 0;
		}
	}

	printf("shit2\n");
	int minrank = RANKMAX;
	int mini = -1, minj = -1;
	int fin = 0;
	while (k < count) {
		minrank = RANKMAX;
		fin = 0;

		// find min rank
		for (int i = 0; i < w; i++) {
			for (int j = 0; j < h; j++) {
				int b = i*w + j;
				printf("Checking length of results for block [%d,%d]\n", bx+i, by+j);
				int bn = sc->rlen[bx+i][by+j];
				printf("Block [%d,%d], length %d, index %d\n", i, j, bn, sc->blocki[b]);
				if (sc->blocki[b] >= bn) { fin++; continue; }

				Point p = sc->grid[bx+i][by+j][sc->blocki[b]];
				printf("Condsidering rank %d in block [%d,%d] : %d\n", p.rank, i, j, b);
				if (p.rank < minrank) {
					mini = i;
					minj = j;
					minrank = p.rank;
				}
			}
		}

		// If we've hit the end of all blocks, exit
		if (fin == w*h) break;

		int bestb = mini*w+minj;
		printf("Testing best rank %d from block [%d,%d] : %d - ", minrank, mini, minj, bestb);
		Point bestp = sc->grid[bx+mini][by+minj][sc->blocki[bestb]];
		if (isHit(rect, &bestp)) {
			printf("it's a hit!\n");
			out[k] = bestp;
			k++;
		}
		else printf("not a hit\n");
		sc->blocki[bestb]++;
	}

	return k;
}



// SEARCH IMPLEMENTATIONS -------------------------------------------------------------------------

// baseline search - search full list of points, sorted by rank increasing
int32_t searchBaseline(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	return findHitsS((Rect*)&rect, sc->gridsort, sc->N, out_points, count);
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

	hitchecks = 0;
	int hits = 0;
	int method = 0;

	if ((nx < ny ? nx : ny) < BINARYLIMIT) {
		method = 1;
		if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
		else hits = findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
	} else {
		sc->trim->lx = rect.lx; sc->trim->hx = rect.hx;
		sc->trim->ly = rect.ly; sc->trim->hy = rect.hy;
		if (sc->trim->lx < sc->bounds->lx) sc->trim->lx = sc->bounds->lx;
		if (sc->trim->hx > sc->bounds->hx) sc->trim->hx = sc->bounds->hx;
		if (sc->trim->ly < sc->bounds->ly) sc->trim->ly = sc->bounds->ly;
		if (sc->trim->hy > sc->bounds->hy) sc->trim->hy = sc->bounds->hy;

		int i = floor((sc->trim->lx - sc->bounds->lx) / sc->dx);
		int j = floor((sc->trim->ly - sc->bounds->ly) / sc->dy);
		int p = ceil((sc->trim->hx - sc->bounds->lx) / sc->dx);
		int q = ceil((sc->trim->hy - sc->bounds->ly) / sc->dy);
		if (p > DIVS) p = DIVS;
		if (q > DIVS) q = DIVS;
		int w = p - i;
 		int h = q - j;

		if (w == 1 && h == 1) {
			method = 2;
			printf("grid search %dx%d    - ", w, h);
			if (w == 1 && h == 1) hits = findHitsS((Rect*)&rect, sc->grid[i][j], sc->rlen[i][j], out_points, count);
			else hits = findHitsB(sc, (Rect*)&rect, i, j, w, h, out_points, count);
			printf("%2d hits, %7d hitchecks\n", hits, hitchecks);
		} else {
			method = 3;
			if (nx < ny) hits = rangeHits(sc, rect, sc->xroot, xidxl, xidxr, count, out_points, 1);
			else hits = rangeHits(sc, rect, sc->yroot, yidxl, yidxr, count, out_points, 1);

			if (hits < 0) {
				printf("failure at depth %d - ", -hits);
				int maxtests = 0;
				// Compute maximum number of tests required for grid search
				printf("BOOM (%d,%d,%d,%d) ", i, j, w, h);
				for (int a = 0; a < w; a++) {
					for (int b = 0; b < h; b++) {
						maxtests += sc->rlen[i+a][j+b];
					}
				}
				printf("SHAKALAKA\n");

				if (maxtests < (nx < ny ? nx : ny)) {
					method = 4;
					printf("grid search %dx%d    - ", w, h);
					if (w == 1 && h == 1) hits = findHitsS((Rect*)&rect, sc->grid[i][j], sc->rlen[i][j], out_points, count);
					else { printf("ASS\n"); hits = findHitsB(sc, (Rect*)&rect, i, j, w, h, out_points, count); }
					printf("%2d hits, %7d hitchecks\n", hits, hitchecks);
				} else {
					method = 5;
					if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
					else hits = findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
					printf("%2d hits, %7d hitchecks (w=%d,h=%d)\n", hits, hitchecks, w, h);
				}
			}
		}
	}

	totalhitchecks += hitchecks;
	if (WRITEFILES) {
		FILE *f = fopen("rects.csv", "a");
		fprintf(f, "%f,%f,%f,%f,%d,%d\n", rect.lx, rect.hx, rect.ly, rect.hy, hitchecks, method);
		fclose(f);
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

void buildGrid(GumpSearchContext* sc) {
	sc->blocki = (int*)calloc(100, sizeof(int));
	sc->trim = (Rect*)malloc(sizeof(Rect));

	sc->bounds = (Rect*)malloc(sizeof(Rect));
	sc->bounds->lx = sc->xsort[1].x;
	sc->bounds->hx = sc->xsort[sc->N-2].x;
	sc->bounds->ly = sc->ysort[1].y;
	sc->bounds->hy = sc->ysort[sc->N-2].y;
	sc->area = rectArea(sc->bounds);
	sc->dx = (sc->bounds->hx - sc->bounds->lx) / (float)DIVS;
	sc->dy = (sc->bounds->hy - sc->bounds->ly) / (float)DIVS;
	printf("Bounds are [%f,%f,%f,%f]: dx=%f, dy=%f, area %f\n",
		sc->bounds->lx, sc->bounds->hx, sc->bounds->ly, sc->bounds->hy,
		sc->dx, sc->dy, sc->area
	);

	memcpy(sc->gridsort, sc->xsort, sc->N * sizeof(Point));
	sc->grid = (Point***)calloc(DIVS, sizeof(Point**));
	sc->rlen = (int**)calloc(DIVS, sizeof(int*));
	sc->rect = (Rect**)calloc(DIVS, sizeof(Rect*));
	int xidxl = 0;
	for (int i = 0; i < DIVS; i++) {
		float lx = sc->bounds->lx + (float)i * sc->dx;
		float hx = sc->bounds->lx + (float)(i+1) * sc->dx;
		int xidxr = xidxl + bsearch(&sc->gridsort[xidxl], true, false, hx, 0, sc->N - xidxl + 1);
		int nx = xidxr - xidxl + 1;
		// printf("Building vertical grid for x: [%f,%f], %d points, pos [%d,%d]\n", lx, hx, nx, xidxl, xidxr);
		qsort(&sc->gridsort[xidxl], nx, sizeof(Point), ycomp);

		sc->grid[i] = (Point**)calloc(DIVS, sizeof(Point*));
		sc->rlen[i] = (int*)calloc(DIVS, sizeof(int));
		sc->rect[i] = (Rect*)calloc(DIVS, sizeof(Rect));
		int yidxl = xidxl;
		for (int j = 0; j < DIVS; j++) {
			float ly = sc->bounds->ly + (float)j * sc->dy;
			float hy = sc->bounds->ly + (float)(j+1) * sc->dy;
			int yidxr = yidxl + bsearch(&sc->gridsort[yidxl], false, false, hy, 0, xidxr - yidxl + 1);
			int ny = yidxr - yidxl + 1;
			// printf("Building grid element [%d,%d] for y: [%f,%f], %d points, pos [%d,%d]\n", i, j, ly, hy, ny, yidxl, yidxr);

			if (ny == 0) {
				sc->rlen[i][j] = 0;
				sc->grid[i][j] = NULL;
			} else {
				sc->rlen[i][j] = ny;
				qsort(&sc->gridsort[yidxl], ny, sizeof(Point), rankcomp);
				sc->grid[i][j] = &sc->gridsort[yidxl];
			}
			sc->rect[i][j].lx = lx;
			sc->rect[i][j].ly = ly;
			sc->rect[i][j].hx = hx;
			sc->rect[i][j].hy = hy;

			yidxl = yidxr + 1;
		}

		xidxl = xidxr + 1;
	}

	for (int i = 0; i < DIVS; i++) {
		for (int j = 0; j < DIVS; j++) {
			printf("%d results in block [%d,%d]\n", sc->rlen[i][j], i, j);
		}
	}
}

void freeGrid(GumpSearchContext* sc) {
	printf("free A\n");
	free(sc->gridsort);
	printf("free B\n");
	free(sc->blocki);
	printf("free C\n");
	for (int i = 0; i < DIVS; i++) {
		free(sc->grid[i]);
		free(sc->rlen[i]);
		free(sc->rect[i]);
	}
	printf("free D\n");
	free(sc->grid);
	printf("free E\n");
	free(sc->rlen);
	printf("free F\n");
	free(sc->rect);
	printf("free G\n");
	free(sc->bounds);
	printf("free H\n");
	free(sc->blocki);
	printf("free I\n");
	free(sc->trim);
}

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* sc = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	sc->N = points_end - points_begin;
	if (sc->N == 0) return (SearchContext*)sc;

	sc->xsort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ysort = (Point*)calloc(sc->N, sizeof(Point));
	sc->gridsort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xsort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ysort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->gridsort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xsort, sc->N, sizeof(Point), xcomp);
	qsort(sc->ysort, sc->N, sizeof(Point), ycomp);
	qsort(sc->gridsort, sc->N, sizeof(Point), rankcomp);

	sc->xroot = buildRange(sc, 0, sc->N-1, selx, true, NULL, NULL, 1);
	sc->yroot = buildRange(sc, 0, sc->N-1, sely, false, NULL, NULL, 1);

	buildGrid(sc);

	if (WRITEFILES) {
		FILE *f = fopen("points.csv", "w");
		for (int i = 0; i < sc->N; i++) {
			fprintf(f, "%d,%f,%f\n", sc->gridsort[i].rank, sc->gridsort[i].x, sc->gridsort[i].y);
		}
		fclose(f);
		remove("rects.csv");
	}

	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	printRect(rect);
	int hits = searchRange(context, rect, count, out_points);
	printPoints(out_points, hits);
	return hits;
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) {
		free(context);
		return NULL;
	}

	printf("free 1\n");
	free(context->xsort);
	printf("free 2\n");
	free(context->ysort);
	printf("free 3\n");
	freeRange(context->xroot, true, true);
	printf("free 4\n");
	freeRange(context->yroot, true, true);
	printf("free 5\n");
	freeGrid(context);
	printf("free 6\n");
	free(context);
	return NULL;
}