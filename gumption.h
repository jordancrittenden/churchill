#ifndef GUMP_H
#define GUMP_H

#include "point_search.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef EXPORT_DLL
#define DLL_API __declspec(dllexport)
#else
#define DLL_API __declspec(dllimport)
#endif

struct GumpSearchContext {
	int32_t N;

	// Basic search variables
	Point* ranksort;

	// Grid search variables
	Point***** grid;
	Rect**** rect;
	int**** rlen;
	Rect* bounds;
	float dx, dy;
	Rect* trim;

	// Binary search variables
	Point* xrank;
	Point* yrank;
	float* xsort;
	float* ysort;
	int* blocki;
	int* blockr;
};

SearchContext* __stdcall DLL_API create(const Point* points_begin, const Point* points_end);
int32_t __stdcall DLL_API search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points);
SearchContext* __stdcall DLL_API destroy(SearchContext* sc);

#ifdef __cplusplus
}
#endif

#endif