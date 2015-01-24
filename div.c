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

	sc->dx = (sc->bounds->hx - sc->bounds->lx) / DIVS;
	sc->dy = (sc->bounds->hy - sc->bounds->ly) / DIVS;

	int d = DIVS;
	sc->grid = (Point*****)calloc(d, sizeof(Point****));
	sc->rlen = (int****)calloc(d, sizeof(int***));
	sc->rect = (Rect****)calloc(d, sizeof(Rect***));
	for (int w = 1; w <= d; w *= 2) {
		int wi = log2(w);
		int xs = (w == 1) ? 1 : w / 2;
		sc->grid[wi] = (Point****)calloc(d, sizeof(Point***));
		sc->rlen[wi] = (int***)calloc(d, sizeof(int**));
		sc->rect[wi] = (Rect***)calloc(d, sizeof(Rect**));
		for (int h = 1; h <= d; h *= 2) {
			int hi = log2(h);
			int ys = (h == 1) ? 1 : h / 2;
			sc->grid[wi][hi] = (Point***)calloc(d, sizeof(Point**));
			sc->rlen[wi][hi] = (int**)calloc(d, sizeof(int*));
			sc->rect[wi][hi] = (Rect**)calloc(d, sizeof(Rect*));
			for (int i = 0; W+i <= d; i += xs) {
				float lx = sc->bounds->lx + (float)i * sc->dx;
				float hx = sc->bounds->lx + (float)(i + w) * sc->dx;
				sc->grid[wi][hi][i] = (Point**)calloc(d-w+1, sizeof(Point*));
				sc->rlen[wi][hi][i] = (int*)calloc(d-w+1, sizeof(int));
				sc->rect[wi][hi][i] = (Rect*)calloc(d-w+1, sizeof(Rect));
				for (int j = 0; h+j <= d; j += ys) {
					float ly = sc->bounds->ly + (float)j * sc->dy;
					float hy = sc->bounds->ly + (float)(j + h) * sc->dy;
					sc->rect[wi][hi][i][j].lx = lx;
					sc->rect[wi][hi][i][j].ly = ly;
					sc->rect[wi][hi][i][j].hx = hx;
					sc->rect[wi][hi][i][j].hy = hy;

					// if (area / rectArea(&sc->rect[wi][hi][i][j]) < AREALIMIT) {
					// 	sc->rlen[i][j][w][h] = -1;
					// 	continue;
					// }

					int size = (w == 0 || h == 0) ? SMALLBLOCK : BIGBLOCK;
					sc->grid[wi][hi][i][j] = (Point*)calloc(size, sizeof(Point));
					sc->rlen[wi][hi][i][j] = findHitsS(&sc->rect[wi][hi][i][j], sc->ranksort, sc->N, sc->grid[wi][hi][i][j], size);
				}
			}
		}
	}

	FILE *f = fopen("points.csv", "w");
	for (int i = 0; i < sc->N; i++) {
		fprintf(f, "%d,%f,%f\n", sc->ranksort[i].rank, sc->ranksort[i].x, sc->ranksort[i].y);
	}
	fclose(f);

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
	for (int w = 1; w <= DIVS; w *= 2) {
		int wi = log2(w);
		int xs = (w == 1) ? 1 : w / 2;
		for (int h = 1; h <= DIVS; h *= 2) {
			int hi = log2(h);
			int ys = (h == 1) ? 1 : h / 2;
			for (int i = 0; w+i <= DIVS; i += xs) {
				for (int j = 0; h+j <= DIVS; j += ys) {
					free(context->grid[wi][hi][i][j]);
				}
				free(context->grid[wi][hi][i]);
				free(context->rlen[wi][hi][i]);
				free(context->rect[wi][hi][i]);
			}
			free(context->grid[wi][hi]);
			free(context->rlen[wi][hi]);
			free(context->rect[wi][hi]);
		}
		free(context->grid[wi]);
		free(context->rlen[wi]);
		free(context->rect[wi]);
	}
	return NULL;
}