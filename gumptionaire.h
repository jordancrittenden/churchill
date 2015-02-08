#include "point_search.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef EXPORT_DLL
#define DLL_API __declspec(dllexport)
#else
#define DLL_API __declspec(dllimport)
#endif

struct Points {
	int n;
	int8_t* id;
	int32_t* rank;
	float* x;
	float* y;
};

struct Region {
	int n;
	Point* ranksort;

	Points* rankpoints;
	Rect* rect;
	Rect* crect;
	Region* left;
	Region* right;
	Region* lrmid;
	Region* bottom;
	Region* top;
	Region* btmid;
};

struct GumpSearchContext {
	int32_t N;

	// Binary search
	Point* xsort;
	Point* ysort;
	Points* xpoints;
	Points* ypoints;

	// Region search
	Point* ranksort;
	Region* root;
	Rect* trim;

	// Grid search
	Point* gridsort;
	Point*** grid;
	Points** gridpoints;
	Rect** grect;
	Rect** drect;
	int** dlen;
	Rect* bounds;
	double area;
	double dx, dy;
	Point** blocks;
	int* blocki;
	int* blockn;
};

SearchContext* __stdcall DLL_API create(const Point* points_begin, const Point* points_end);
int32_t __stdcall DLL_API search(SearchContext* sc, const Rect rect, const int32_t count, Point* out_points);
SearchContext* __stdcall DLL_API destroy(SearchContext* sc);

#ifdef __cplusplus
}
#endif