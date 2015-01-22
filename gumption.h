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

struct TreeNode {
	int32_t N;
	Rect* rect;
	Point* ranksort;
	TreeNode** children;
	Point* hits1;
	Point* hits3;
	Point* hits7;
	Point* hits9;
};

struct GumpSearchContext {
	int32_t N;
	TreeNode* root;
	Point* ranksort;
	Point* xsort;
	Point* ysort;
};

SearchContext* __stdcall DLL_API create(const Point* points_begin, const Point* points_end);
int32_t __stdcall DLL_API search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points);
SearchContext* __stdcall DLL_API destroy(SearchContext* sc);

#ifdef __cplusplus
}
#endif

#endif