import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article.dart';

class ArticleList extends StatefulWidget {
  /// A list of the available [articles].
  ///
  /// The list is searchable using a [SearchBar] widget.
  ///
  /// TODO: Fetch the articles dynamically from a database.
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  /// The controller for the search bar.
  final TextEditingController searchController = TextEditingController();

  /// The current search query that the user has entered.
  String get searchQuery => searchController.text.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    /// The articles that match the current [searchQuery].
    final Iterable<Article> filteredArticles = articles.where((article) =>
        article.title.toLowerCase().contains(searchQuery) ||
        article.description?.toLowerCase().contains(searchQuery) == true);

    return SizedBox(
      width: switch (windowSize) {
        WindowSize.compact || WindowSize.medium => null,
        WindowSize.expanded || WindowSize.large => 360,
        WindowSize.extraLarge => 412,
      },
      child: Padding(
        padding: switch (windowSize) {
          WindowSize.compact || WindowSize.medium => windowSize.margin,
          _ => EdgeInsets.zero,
        },
        child: Column(
          children: [
            SizedBox(height: 24),
            SearchBar(
              controller: searchController,
              elevation: WidgetStatePropertyAll(0),
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: Icon(Icons.search),
              trailing: [
                if (searchQuery.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                      });
                    },
                    icon: Icon(Icons.clear),
                  ),
              ],
              onChanged: (value) {
                setState(() {});
              },
              hintText: "Search moments",
            ),
            SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final article in filteredArticles)
                    _buildArticleTile(context, article),
                  if (filteredArticles.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No moments found. Try a different search query.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleTile(BuildContext context, Article article) {
    final bool isSelected = GoRouter.of(context)
            .routeInformationProvider
            .value
            .uri
            .pathSegments
            .last ==
        article.id;

    return SizedBox(
      height: 120,
      child: Card(
        elevation: 0,
        color: isSelected
            ? Theme.of(context).colorScheme.secondaryContainer
            : null,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.go("/writing/${article.id}");
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 1,
                child: article.image != null
                    ? Image(
                        image: article.image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.notes,
                        size: 48,
                      ),
              ),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _buildArticleText(context, article),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleText(BuildContext context, Article article) {
    final Color subtitleColor =
        Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(0xaa);
    final TextStyle? descriptionStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: subtitleColor,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          article.title,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (article.description != null)
          Text(
            article.description!,
            style: descriptionStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (article.writtenAt != null)
          RichText(
            text: TextSpan(
              style: descriptionStyle,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.event, color: subtitleColor),
                  ),
                ),
                TextSpan(
                  text: DateFormat("dd MMMM, yyyy").format(article.writtenAt!),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}
