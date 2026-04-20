import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routes/route_path.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../widgets/article_card.dart';
import '../widgets/category_chips.dart';
import '../widgets/news_shimmer.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  final List<String> _categories = ['general', 'business', 'technology', 'sports', 'health', 'science', 'entertainment'];
  String _selectedCategory = 'general';

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(FetchTopHeadlines(category: _selectedCategory));
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory == category && _searchController.text.isEmpty) return; // Ignore if already selected and not searching
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
    });
    if (_scrollController.hasClients) {
      _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    context.read<NewsBloc>().add(FetchTopHeadlines(category: _selectedCategory));
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (query.trim().isNotEmpty) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        }
        context.read<NewsBloc>().add(SearchNews(query));
      } else {
        context.read<NewsBloc>().add(FetchTopHeadlines(category: _selectedCategory));
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///--------------------- Header & Search
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "News from all around the world",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Search Bar
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      onSubmitted: _onSearch,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: "Search news...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Categories
            CategoryChips(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onSelected: _onCategorySelected,
            ),
            SizedBox(height: 20.h),

            // Articles List
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading || state is NewsInitial) {
                    return const NewsShimmer();
                  } else if (state is NewsLoaded) {
                    final articles = state.articles;
                    return RefreshIndicator(
                      onRefresh: () async {
                         if (_searchController.text.trim().isNotEmpty) {
                           context.read<NewsBloc>().add(SearchNews(_searchController.text.trim()));
                         } else {
                           context.read<NewsBloc>().add(FetchTopHeadlines(category: _selectedCategory));
                         }
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return ArticleCard(
                            article: articles[index],
                            onTap: () {
                              context.push(RoutePath.articleDetailPagePath, extra: articles[index]);
                            },
                          );
                        },
                      ),
                    );
                  } else if (state is NewsEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.feed_outlined, size: 64.sp, color: Colors.grey.shade400),
                          SizedBox(height: 16.h),
                          Text(state.message, style: TextStyle(color: Colors.grey.shade600, fontSize: 16.sp)),
                        ],
                      ),
                    );
                  } else if (state is NewsError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64.sp, color: Colors.red[300]),
                            SizedBox(height: 16.h),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade800, fontSize: 16.sp),
                            ),
                            SizedBox(height: 20.h),
                            ElevatedButton(
                              onPressed: () => _onCategorySelected(_selectedCategory),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE54B4B)),
                              child: const Text("Retry", style: TextStyle(color: Colors.white)),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
