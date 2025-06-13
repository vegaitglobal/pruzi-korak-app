import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_components.dart';

class InfiniteScrollView extends StatefulWidget {
  final Widget Function(BuildContext, int) itemBuilder;
  final Future<void> Function() fetchMore;
  final Future<void> Function() onRefresh;
  final int itemCount;
  final bool isLastPage;
  final bool loadingEnabled; // Fix when we use section list

  const InfiniteScrollView({
    super.key,
    required this.itemBuilder,
    required this.fetchMore,
    required this.itemCount,
    required this.onRefresh,
    required this.isLastPage,
    required this.loadingEnabled,
  });

  @override
  State<InfiniteScrollView> createState() => _InfiniteScrollViewState();
}

class _InfiniteScrollViewState extends State<InfiniteScrollView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  Timer? _debounce;

  bool _firstTimeLoad = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          await _fetchMoreData();
          if (!_firstTimeLoad) {
            setState(() {
              _firstTimeLoad = true;
            });
          }
        });
      }
    });
  }

  Future<void> _fetchMoreData() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    await widget.fetchMore();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: widget.onRefresh,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (_shouldShowLoading(index)) {
                      return const Column(
                        children: [
                          SizedBox(height: 8),
                          Center(child: AppLoader()),
                        ],
                      );
                    }
                    return widget.itemBuilder(context, index);
                  },
                  childCount: widget.itemCount + (_isLoading ? 1 : 0),
                ),
              ),
            ],
          )
        : RefreshIndicator(
            onRefresh: widget.onRefresh,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.itemCount + (_isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                if (_shouldShowLoading(index)) {
                  return const Column(
                    children: [
                      SizedBox(height: 8),
                      Center(child: AppLoader()),
                    ],
                  );
                }
                return widget.itemBuilder(context, index);
              },
            ),
          );
  }

  bool _shouldShowLoading(int index) {
    return widget.loadingEnabled &&
        widget.itemCount > 1 &&
        index >= widget.itemCount - 1 &&
        !widget.isLastPage;
  }
}
