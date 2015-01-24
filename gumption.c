#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "gumption.h"

#define DEBUG 1
#define DIVS 12.0f
#define RANKSIZE 2000
#define RANKLIMIT 10000
#define BINARYLIMIT 1000
#define BLOCKSIZE 5000
#define RANKMAX 100000000

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

int32_t findHitsU(const Rect* rect, Point* in, int n, Point* out, int count, bool (*hitcheck)(const Rect* r, Point* p)) {
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
		hitchecks++;
		if (p.x >= rect->lx && p.x <= rect->hx && p.y >= rect->ly && p.y <= rect->hy) {
			out[k] = p;
			k++;
		}
		i++;
	}

	return k;
}

int32_t findHitsB(GumpSearchContext* sc, Rect* rect, Point* in, int idxl, int idxr, Point* out, int count) {
	int32_t k = 0;

	printf("idxl = %d, idxr = %d\n", idxl, idxr);
	int lblockstart = idxl - (idxl % BLOCKSIZE);
	int rblockstart = idxr - (idxr % BLOCKSIZE);
	int nblocks = (rblockstart - lblockstart) / BLOCKSIZE + 1;
	// printf("Searching %d subblocks\n", nblocks);

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
				// printf("Searching for first hit in block %d\n", i);
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
		// printf("Added point [%f,%f] = rank %d to results\n", out[k].x, out[k].y, out[k].rank);
		k++;
	}

	return k;
}



// SEARCH IMPLEMENTATION --------------------------------------------------------------------------

int32_t searchBinary(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int32_t n = 0;
	printf("Binary search\n");
	int xidxl = bsearch(sc->xsort, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, rect.hy, 0, sc->N);
	printf("Found bounds [%d,%d,%d,%d]\n", xidxl, xidxr, yidxl, yidxr);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	if (nx < ny) return findHitsB(sc, (Rect*)&rect, sc->xrank, xidxl, xidxr, out_points, count);
	else return findHitsB(sc, (Rect*)&rect, sc->yrank, yidxl, yidxr, out_points, count);
}

int32_t searchGrid(GumpSearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	int xidxl = bsearch(sc->xsort, true, rect.lx, 0, sc->N);
	int xidxr = bsearch(sc->xsort, false, rect.hx, 0, sc->N);
	int yidxl = bsearch(sc->ysort, true, rect.ly, 0, sc->N);
	int yidxr = bsearch(sc->ysort, false, rect.hy, 0, sc->N);
	int nx = xidxr - xidxl + 1;
	int ny = yidxr - yidxl + 1;

	if (nx == 0 || ny == 0) return 0;

	hitchecks = 0;

	// use simple binary if small range
	if ((nx < ny ? nx : ny) < BINARYLIMIT) {
		printf("Initial fallback on binary search\n");
		if (nx < ny) return findHitsB(sc, (Rect*)&rect, sc->xrank, xidxl, xidxr, out_points, count);
		else return findHitsB(sc, (Rect*)&rect, sc->yrank, yidxl, yidxr, out_points, count);
	}

	sc->trim->lx = rect.lx; sc->trim->hx = rect.hx;
	sc->trim->ly = rect.ly; sc->trim->hy = rect.hy;
	if (sc->trim->lx > sc->xmax || sc->trim->hx < sc->xmin || sc->trim->ly > sc->ymax || sc->trim->hy < sc->ymin) return 0;
	if (sc->trim->lx < sc->xmin) sc->trim->lx = sc->xmin;
	if (sc->trim->hx > sc->xmax) sc->trim->hx = sc->xmax;
	if (sc->trim->ly < sc->ymin) sc->trim->ly = sc->ymin;
	if (sc->trim->hy > sc->ymax) sc->trim->hy = sc->ymax;

	float xmini = (sc->trim->lx - sc->xmin) / sc->dx;
	float ymini = (sc->trim->ly - sc->ymin) / sc->dy;
	float xmaxi = (sc->trim->hx - sc->xmin) / sc->dx;
	float ymaxi = (sc->trim->hy - sc->ymin) / sc->dy;

	int i = floor(xmini);
	int j = floor(ymini);
	int w = ceil(xmaxi) - i - 1;
	int h = ceil(ymaxi) - j - 1;

	printf("Checking trimmed rect "); printRect(*sc->trim);
	printf("Checking %d points in rect [%d,%d,%d,%d] ", sc->rlen[i][j][w][h], i, j, w, h); printRect(sc->rect[i][j][w][h]);
	int hits = findHitsS(sc->trim, sc->grid[i][j][w][h], sc->rlen[i][j][w][h], out_points, count);

	if (hits < 20 && sc->rlen[i][j][w][h] > 20) {
		printf("Found %d hits - falling back on binary search\n", hits);
		if (nx < ny) hits = findHitsB(sc, (Rect*)&rect, sc->xrank, xidxl, xidxr, out_points, count);
		else hits = findHitsB(sc, (Rect*)&rect, sc->yrank, yidxl, yidxr, out_points, count);
		printf("%d checks (%d total)\n", hitchecks, totalhitchecks);
	}

	totalhitchecks += hitchecks;

	return hits;
}



// DLL IMPLEMENTATION -----------------------------------------------------------------------------

int nodes = 0;

__stdcall SearchContext* create(const Point* points_begin, const Point* points_end) {
	GumpSearchContext* sc = (GumpSearchContext*)malloc(sizeof(GumpSearchContext));
	sc->N = points_end - points_begin;
	if (sc->N == 0) return (SearchContext*)sc;

	printf("Allocating memory and sorting shit\n");
	sc->xrank = (Point*)calloc(sc->N, sizeof(Point));
	sc->yrank = (Point*)calloc(sc->N, sizeof(Point));
	sc->xsort = (float*)calloc(sc->N, sizeof(float));
	sc->ysort = (float*)calloc(sc->N, sizeof(float));
	sc->ranksort = (Point*)calloc(sc->N, sizeof(Point));
	memcpy(sc->xrank, points_begin, sc->N * sizeof(Point));
	memcpy(sc->yrank, points_begin, sc->N * sizeof(Point));
	memcpy(sc->ranksort, points_begin, sc->N * sizeof(Point));
	qsort(sc->xrank, sc->N, sizeof(Point), xcomp);
	qsort(sc->yrank, sc->N, sizeof(Point), ycomp);
	qsort(sc->ranksort, sc->N, sizeof(Point), rankcomp);

	for (int i = 0; i < sc->N; i++) {
		sc->xsort[i] = sc->xrank[i].x;
		sc->ysort[i] = sc->yrank[i].y;
	}

	for (int i = 0; i < sc->N; i += BLOCKSIZE) {
		qsort(&sc->xrank[i], BLOCKSIZE, sizeof(Point), rankcomp);
		qsort(&sc->yrank[i], BLOCKSIZE, sizeof(Point), rankcomp);
	}

	sc->blocki = (int*)calloc(100, sizeof(int));
	sc->blockr = (int*)calloc(100, sizeof(int));

	sc->xmin = sc->xrank[1].x;
	sc->xmax = sc->xrank[sc->N-2].x;
	sc->ymin = sc->yrank[1].y;
	sc->ymax = sc->yrank[sc->N-2].y;

	sc->dx = (sc->xmax - sc->xmin) / DIVS;
	sc->dy = (sc->ymax - sc->ymin) / DIVS;

	printf("Bounds are [%f,%f,%f,%f], dx = %f, dy = %f\n", sc->xmin, sc->xmax, sc->ymin, sc->ymax, sc->dx, sc->dy);

	Rect rect;
	sc->grid = (Point*****)calloc(DIVS, sizeof(Point****));
	sc->rlen = (int****)calloc(DIVS, sizeof(int***));
	sc->rect = (Rect****)calloc(DIVS, sizeof(Rect***));
	for (int i = 0; i < DIVS; i++) {
		rect.lx = sc->xmin + (float)i * sc->dx;
		sc->grid[i] = (Point****)calloc(DIVS, sizeof(Point***));
		sc->rlen[i] = (int***)calloc(DIVS, sizeof(int**));
		sc->rect[i] = (Rect***)calloc(DIVS, sizeof(Rect**));
		for (int j = 0; j < DIVS; j++) {
			rect.ly = sc->ymin + (float)j * sc->dy;
			sc->grid[i][j] = (Point***)calloc(DIVS, sizeof(Point**));
			sc->rlen[i][j] = (int**)calloc(DIVS, sizeof(int*));
			sc->rect[i][j] = (Rect**)calloc(DIVS, sizeof(Rect*));
			for (int w = 0; w < DIVS - i; w++) {
				rect.hx = sc->xmin + (float)(i + w + 1) * sc->dx;
				sc->grid[i][j][w] = (Point**)calloc(DIVS-j, sizeof(Point*));
				sc->rlen[i][j][w] = (int*)calloc(DIVS-j, sizeof(int));
				sc->rect[i][j][w] = (Rect*)calloc(DIVS-j, sizeof(Rect));
				for (int h = 0; h < DIVS - j; h++) {
					rect.hy = sc->ymin + (float)(j + h + 1) * sc->dy;
					sc->rect[i][j][w][h].lx = rect.lx;
					sc->rect[i][j][w][h].ly = rect.ly;
					sc->rect[i][j][w][h].hx = rect.hx;
					sc->rect[i][j][w][h].hy = rect.hy;
					sc->grid[i][j][w][h] = (Point*)calloc(RANKSIZE, sizeof(Point));
					sc->rlen[i][j][w][h] = findHitsS(&rect, sc->ranksort, sc->N, sc->grid[i][j][w][h], RANKSIZE);
				}
			}
		}
	}

	sc->trim = (Rect*)malloc(sizeof(Rect));

	FILE *f = fopen("points.csv", "w");
	for (int i = 0; i < sc->N; i++) {
		fprintf(f, "%d,%f,%f\n", sc->ranksort[i].rank, sc->ranksort[i].x, sc->ranksort[i].y);
	}
	fclose(f);

	free(sc->ranksort);
	return (SearchContext*)sc;
}

__stdcall int32_t search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points) {
	// FILE *f = fopen("rects.csv", "a");
	// fprintf(f, "%f,%f,%f,%f\n", rect.lx, rect.ly, rect.hx, rect.hy);
	// fclose(f);

	printRect(rect);
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return 0;
	int hits = searchGrid(context, rect, count, out_points);
	printPoints(out_points, hits);
	return hits;
}

__stdcall SearchContext* destroy(SearchContext* sc) {
	GumpSearchContext* context = (GumpSearchContext*)sc;
	if (context->N == 0) return NULL;

	free(context->xsort);
	free(context->ysort);
	free(context->xrank);
	free(context->yrank);
	free(context->blocki);
	free(context->blockr);
	free(context->trim);
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
	return NULL;
}