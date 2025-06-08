import 'package:flutter/material.dart';
import '../../../shared/services/pdf_core/pdf_core.dart';
import '../models/pdf_viewer_view_model.dart';

class PdfSidebar extends StatelessWidget {
  final PdfViewerViewModel viewModel;
  final Function(BasePage) onPageSelected;
  final Function(BaseLayout) onLayoutSelected;

  const PdfSidebar({
    super.key,
    required this.viewModel,
    required this.onPageSelected,
    required this.onLayoutSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(left: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          // Tab Toggle
          _buildTabToggle(context),

          // Content List
          Expanded(
            child:
                viewModel.selectedTabIndex == 0
                    ? _PageListView(
                      pages: viewModel.filteredPages,
                      onPageSelected: onPageSelected,
                    )
                    : _LayoutListView(
                      layouts: viewModel.filteredLayouts,
                      onLayoutSelected: onLayoutSelected,
                    ),
          ),

          // Search Bar
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildTabToggle(BuildContext context) {
    return ToggleButtons(
      isSelected: [
        viewModel.selectedTabIndex == 0,
        viewModel.selectedTabIndex == 1,
      ],
      onPressed: viewModel.selectTab,
      borderRadius: BorderRadius.circular(20),
      selectedBorderColor: Theme.of(context).colorScheme.onSecondaryContainer,
      fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      selectedColor: Theme.of(context).colorScheme.onSecondaryContainer,
      color: Theme.of(context).colorScheme.onSurface,
      constraints: const BoxConstraints(minWidth: 100, minHeight: 36),
      children: [
        Text('Page', style: Theme.of(context).textTheme.bodyMedium),
        Text('Figure', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText:
              viewModel.selectedTabIndex == 0 ? 'Search Page' : 'Search Figure',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              viewModel.searchQuery.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: viewModel.clearSearch,
                  )
                  : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
        ),
        onChanged: viewModel.updateSearchQuery,
      ),
    );
  }
}

class _PageListView extends StatelessWidget {
  final List<BasePage> pages;
  final Function(BasePage) onPageSelected;

  const _PageListView({required this.pages, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return ListTile(
          leading: _buildPageThumbnail(page, context: context),
          title: Text('Page ${page.pageIndex}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onPageSelected(page),
        );
      },
    );
  }

  Widget _buildPageThumbnail(BasePage page, {required BuildContext context}) {
    // For now, use a placeholder. In a real implementation,
    // you would render the page thumbnail using pdfrx
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.picture_as_pdf, color: Colors.grey),
    );
  }
}

class _LayoutListView extends StatelessWidget {
  final List<BaseLayout> layouts;
  final Function(BaseLayout) onLayoutSelected;

  const _LayoutListView({
    required this.layouts,
    required this.onLayoutSelected,
  });

  @override
  Widget build(BuildContext context) {
    final figures =
        layouts.where((layout) => layout.type == LayoutType.figure).toList();
    return ListView.builder(
      itemCount: figures.length,
      itemBuilder: (context, index) {
        final layout = figures[index];
        return ListTile(
          leading: _buildLayoutThumbnail(layout, context: context),
          title: Text(layout.figureId ?? 'Figure ${index + 1}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onLayoutSelected(layout),
        );
      },
    );
  }

  Widget _buildLayoutThumbnail(
    BaseLayout layout, {
    required BuildContext context,
  }) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, color: Colors.grey[700]),
          if (layout.type == LayoutType.figure && layout.figureNumber != null)
            Text(
              'Fig ${layout.figureNumber}',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
          if (layout.type == LayoutType.figureReference &&
              layout.figureNumber != null)
            Text(
              'Ref ${layout.figureNumber}',
              style: const TextStyle(fontSize: 10, color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
