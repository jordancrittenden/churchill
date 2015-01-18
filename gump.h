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
	int ximin, ximax;
	int yimin, yimax;
	Rect* rect;
	TreeNode* tr;
	TreeNode* tl;
	TreeNode* bl;
	TreeNode* br;
	Point* myPoints;
	int myN;
	Point* childPoints;
	int childN;
	Point* my5xPoints;
	int my5xN;
};

struct Range {
	int l, r;
	bool leaf;
	Point* ranksort;
	Point* ranksorttop;
	Range* left;
	Range* right;
	Range* mid;
};

struct GumpSearchContext {
	int32_t N;
	Point* xsort;
	Point* ysort;
	Point* ranksort;
	Range* xroot;
	Range* yroot;
};

SearchContext* __stdcall DLL_API create(const Point* points_begin, const Point* points_end);
int32_t __stdcall DLL_API search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points);
SearchContext* __stdcall DLL_API destroy(SearchContext* sc);

#ifdef __cplusplus
}
#endif

#endif