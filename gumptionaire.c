#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gumptionaire.h"

// #define DEBUG 1
#define WRITEFILES 0

#ifdef DEBUG
	#define DPRINT(x) printf x
#else
	#define DPRINT(x) do {} while (0)
#endif

// rank search parameters
#define BASELIMIT 10000

// binary search parameters
#define BINARYLIMIT 2500

// range search parameters
#define MAXDEPTH 8 //39062.5
#define DEPTHFACTOR 1000

// grid search parameters
#define DIVS 50
#define GRIDFACTOR 2.5f
#define RANKMAX 100000000



// DEBUGGING --------------------------------------------------------------------------------------

void printRect(Rect rect) {
	DPRINT(("[%f, %f, %f, %f]\n", rect.lx, rect.hx, rect.ly, rect.hy));
}

void printPoints(Point* points, int n) {
	for (int i = 0; i < n; i++) {
		DPRINT(("%d, %d, %f, %f\n", points[i].id, points[i].rank, points[i].x, points[i].y));
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

int bvalsearch(float p[], bool minOrMax, float v, int imin, int imax) {
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

	int b = 0;
	for (int i = 0; i < w; i++) {
		for (int j = 0; j < h; j++) {
			if (sc->rlen[bx+i][by+j] == 0) continue;
			sc->blocks[b] = sc->grid[bx+i][by+j];
			sc->blocki[b] = 0;
			sc->blockn[b] = sc->rlen[bx+i][by+j];
			b++;
		}
	}

	if (b == 0) return 0;
	if (b == 1) return findHitsS(rect, sc->blocks[0], sc->blockn[0], out, count);

	int minrank = RANKMAX;
	int minb = -1;
	int fin = 0;
	while (k < count) {
		minrank = RANKMAX;
		fin = 0;

		// find min rank
		for (int i = 0; i < b; i++) {
			if (sc->blocki[i] >= sc->blockn[i]) { fin++; continue; }

			Point p = sc->blocks[i][sc->blocki[i]];
			if (p.rank < minrank) {
				minb = i;
				minrank = p.rank;
			}
		}

		// If we've hit the end of all blocks, exit
		if (fin == b) break;

		Point bestp = sc->blocks[minb][sc->blocki[minb]];
		if (isHit(rect, &bestp)) {
			out[k] = bestp;
			k++;
		}
		sc->blocki[minb]++;
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

int32_t searchGumption(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bvalsearch(sc->xvalsort, true, rect.lx, 0, sc->N);
	int xidxr = bvalsearch(sc->xvalsort, false, rect.hx, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	if (nx == 0) return 0;

	int yidxl = bvalsearch(sc->yvalsort, true, rect.ly, 0, sc->N);
	int yidxr = bvalsearch(sc->yvalsort, false, rect.hy, 0, sc->N);
	int ny = yidxr - yidxl + 1;
	if (ny == 0) return 0;

	// short circuit to binary search
	if ((nx < ny ? nx : ny) < BINARYLIMIT) {
		if (nx < ny) return findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
		else return findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
	}

	int hits = 0;

	// find grid block for the bottom left and top right corners of the query rect
	// subtract FLT_MIN to handle cases where bottom left is on a bottom or left grid boundary
	// double fi = ((double)rect.lx - (double)sc->bounds->lx) / sc->dx;
	// double fj = ((double)rect.ly - (double)sc->bounds->ly) / sc->dy;
	// double fp = ((double)rect.hx - (double)sc->bounds->lx) / sc->dx;
	// double fq = ((double)rect.hy - (double)sc->bounds->ly) / sc->dy;
	// printf("%f,%f,%f,%f\n", fi, fj, fp, fq);
	int i = floor((rect.lx - sc->bounds->lx) / sc->dx - 0.001f); if (i < 0) i = 0;
	int j = floor((rect.ly - sc->bounds->ly) / sc->dy - 0.001f); if (j < 0) j = 0;
	int p = ceil((rect.hx - sc->bounds->lx) / sc->dx); if (p > DIVS) p = DIVS;
	int q = ceil((rect.hy - sc->bounds->ly) / sc->dy); if (q > DIVS) q = DIVS;
	
	int w = p - i;
	int h = q - j;

	// short circuit to binary or grid search
	if (w*h <= 4) {
		// Compute maximum number of tests required for grid search
		int maxtests = 0;
		for (int a = 0; a < w; a++) {
			for (int b = 0; b < h; b++) {
				maxtests += sc->rlen[i+a][j+b];
			}
		}

		if ((float)maxtests * GRIDFACTOR < (float)(nx < ny ? nx : ny)) {
			return findHitsB(sc, (Rect*)&rect, i, j, w, h, out_points, count);
		} else {
			if (nx < ny) return findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
			else return findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
		}
	}

	// run range search
	if (nx < ny) hits = rangeHits(sc, rect, sc->xroot, xidxl, xidxr, count, out_points, 1);
	else hits = rangeHits(sc, rect, sc->yroot, yidxl, yidxr, count, out_points, 1);

	// if range search fails, fall back on grid or binary
	if (hits < 0) {
		int maxtests = 0;
		for (int a = 0; a < w; a++) {
			for (int b = 0; b < h; b++) {
				maxtests += sc->rlen[i+a][j+b];
			}
		}

		if ((float)maxtests * GRIDFACTOR < (float)(nx < ny ? nx : ny)) {
			if (w == 1 && h == 1) return findHitsS((Rect*)&rect, sc->grid[i][j], sc->rlen[i][j], out_points, count);
			else return findHitsB(sc, (Rect*)&rect, i, j, w, h, out_points, count);
		} else {
			if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
			else return findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
		}
	}

	return hits;
}

// hitchecks = -1;
// if (w*h < 100) {
// 	if (w == 1 && h == 1) hits = findHitsS((Rect*)&rect, sc->grid[i][j], sc->rlen[i][j], out_points, count);
// 	else hits = findHitsB(sc, (Rect*)&rect, i, j, w, h, out_points, count);
// }
// int gridchecks = hitchecks;

// hitchecks = 0;
// if (nx < ny) hits = rangeHits(sc, rect, sc->xroot, xidxl, xidxr, count, out_points, 1);
// else hits = rangeHits(sc, rect, sc->yroot, yidxl, yidxr, count, out_points, 1);
// int rangechecks = hits < 0 ? -1 : hitchecks;

// hitchecks = 0;
// if (nx < ny) hits = findHitsU((Rect*)&rect, &sc->xsort[xidxl], nx, out_points, count, isHitY);
// else hits = findHitsU((Rect*)&rect, &sc->ysort[yidxl], ny, out_points, count, isHitX);
// int binarychecks = hitchecks;

// if (WRITEFILES) {
// 	FILE *f = fopen("rects.csv", "a");
// 	fprintf(f, "%f,%f,%f,%f,%d,%d,%d,%d,%d,%d,%d,%d\n",
// 		rect.lx, rect.hx, rect.ly, rect.hy,
// 		nx, ny, w, h, maxtests,
// 		gridchecks, rangechecks, binarychecks
// 	);
// 	fclose(f);
// }



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
	sc->blocks = (Point**)calloc(100, sizeof(Point*));
	sc->blocki = (int*)calloc(100, sizeof(int));
	sc->blockn = (int*)calloc(100, sizeof(int));

	sc->bounds = (Rect*)malloc(sizeof(Rect));
	sc->bounds->lx = sc->xsort[1].x;
	sc->bounds->hx = sc->xsort[sc->N-2].x;
	sc->bounds->ly = sc->ysort[1].y;
	sc->bounds->hy = sc->ysort[sc->N-2].y;
	sc->area = rectArea(sc->bounds);
	sc->dx = (double)(sc->bounds->hx - sc->bounds->lx) / (double)DIVS;
	sc->dy = (double)(sc->bounds->hy - sc->bounds->ly) / (double)DIVS;
	DPRINT(("Bounds are [%f,%f,%f,%f]: dx=%f, dy=%f, area %f\n",
		sc->bounds->lx, sc->bounds->hx, sc->bounds->ly, sc->bounds->hy,
		sc->dx, sc->dy, sc->area
	));

	memcpy(sc->gridsort, sc->xsort, sc->N * sizeof(Point));
	sc->grid = (Point***)calloc(DIVS, sizeof(Point**));
	sc->rlen = (int**)calloc(DIVS, sizeof(int*));
	sc->rect = (Rect**)calloc(DIVS, sizeof(Rect*));
	int xidxl = 0;
	for (int i = 0; i < DIVS; i++) {
		double lx = sc->bounds->lx + (double)i * sc->dx;
		double hx = sc->bounds->lx + (double)(i+1) * sc->dx;
		if (i == DIVS - 1) hx = sc->bounds->hx;
		int xidxr = xidxl + bsearch(&sc->gridsort[xidxl], true, false, hx, 0, sc->N - xidxl + 1);
		int nx = xidxr - xidxl + 1;
		qsort(&sc->gridsort[xidxl], nx, sizeof(Point), ycomp);

		sc->grid[i] = (Point**)calloc(DIVS, sizeof(Point*));
		sc->rlen[i] = (int*)calloc(DIVS, sizeof(int));
		sc->rect[i] = (Rect*)calloc(DIVS, sizeof(Rect));
		int yidxl = xidxl;
		for (int j = 0; j < DIVS; j++) {
			double ly = sc->bounds->ly + (double)j * sc->dy;
			double hy = sc->bounds->ly + (double)(j+1) * sc->dy;
			if (j == DIVS - 1) hy = sc->bounds->hy;
			int yidxr = yidxl + bsearch(&sc->gridsort[yidxl], false, false, hy, 0, xidxr - yidxl + 1);
			int ny = yidxr - yidxl + 1;

			if (ny == 0) {
				sc->rlen[i][j] = 0;
				sc->grid[i][j] = NULL;
			} else {
				sc->rlen[i][j] = ny;
				sc->grid[i][j] = (Point*)calloc(ny, sizeof(Point));
				memcpy(sc->grid[i][j], &sc->gridsort[yidxl], ny * sizeof(Point));
				qsort(sc->grid[i][j], ny, sizeof(Point), rankcomp);
			}
			sc->rect[i][j].lx = lx;
			sc->rect[i][j].ly = ly;
			sc->rect[i][j].hx = hx;
			sc->rect[i][j].hy = hy;

			// If there are points on the boundary, they need to be included in both grid blocks
			if (ny > 0 && sc->gridsort[yidxr].y == hx) {
				yidxl = yidxr;
				while (sc->gridsort[yidxl].y == sc->gridsort[yidxl-1].y) yidxl--;
			} else yidxl = yidxr + 1;
		}

		// If there are points on the boundary, they need to be included in both grid blocks
		if (nx > 0 && sc->gridsort[xidxr].x == hx) {
			xidxl = xidxr;
			while (sc->gridsort[xidxl].x == sc->gridsort[xidxl-1].x) xidxl--;
		} else xidxl = xidxr + 1;
	}
}

void freeGrid(GumpSearchContext* sc) {
	free(sc->blocki);
	for (int i = 0; i < DIVS; i++) {
		for (int j = 0; j < DIVS; j++) {
			free(sc->grid[i][j]);
		}
		free(sc->grid[i]);
		free(sc->rlen[i]);
		free(sc->rect[i]);
	}
	free(sc->grid);
	free(sc->rlen);
	free(sc->rect);
	free(sc->bounds);
	free(sc->blocks);
	free(sc->blocki);
	free(sc->blockn);
}

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* sc = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	sc->N = points_end - points_begin;
	if (sc->N == 0) return (SearchContext*)sc;

	sc->xsort = (Point*)calloc(sc->N, sizeof(Point));
	sc->ysort = (Point*)calloc(sc->N, sizeof(Point));
	sc->xvalsort = (float*)calloc(sc->N, sizeof(float));
	sc->yvalsort = (float*)calloc(sc->N, sizeof(float));
	sc->gridsort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xsort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ysort, points_begin, sc->N * sizeof(Point));
	memcpy(sc->gridsort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xsort, sc->N, sizeof(Point), xcomp);
	qsort(sc->ysort, sc->N, sizeof(Point), ycomp);
	qsort(sc->gridsort, sc->N, sizeof(Point), rankcomp);

	for (int i = 0; i < sc->N; i++) {
		sc->xvalsort[i] = sc->xsort[i].x;
		sc->yvalsort[i] = sc->ysort[i].y;
	}

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

	free(sc->gridsort);

	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	int hits = searchGumption(context, rect, count, out_points);
	printRect(rect);
	printPoints(out_points, hits);
	return hits;
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) {
		free(context);
		return NULL;
	}

	free(context->xsort);
	free(context->ysort);
	free(context->xvalsort);
	free(context->yvalsort);
	freeRange(context->xroot, true, true);
	freeRange(context->yroot, true, true);
	freeGrid(context);
	free(context);
	return NULL;
}