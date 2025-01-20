import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/writing/article_pane.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  final TextEditingController searchController = TextEditingController();
  String get searchQuery => searchController.text.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final Iterable<Article> filteredArticles = articles.where((article) =>
        article.title.toLowerCase().contains(searchQuery) ||
        article.description?.toLowerCase().contains(searchQuery) == true);

    return SizedBox(
      width: switch (windowSize) {
        WindowSize.compact || WindowSize.medium => null,
        WindowSize.expanded || WindowSize.large => 360,
        WindowSize.extraLarge => 412,
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

    return Card(
      elevation: 0,
      color:
          isSelected ? Theme.of(context).colorScheme.secondaryContainer : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.go("/writing/${article.id}");
        },
        child: switch (WindowSize.of(context)) {
          WindowSize.compact => Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: Card.filled(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: AspectRatio(
                        aspectRatio: 1.618,
                        child: Image(
                          // TODO: Create placeholder image
                          image: article.image ??
                              NetworkImage("https://picsum.photos/512/256"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: _buildArticleText(context, article),
                  ),
                ],
              ),
            ),
          WindowSize.medium ||
          WindowSize.expanded ||
          WindowSize.large ||
          WindowSize.extraLarge =>
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Image(
                      // TODO: Create placeholder image
                      image: article.image ??
                          NetworkImage("https://picsum.photos/512/256"),
                      fit: BoxFit.cover,
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
        },
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
        ),
        if (article.description != null)
          Text(
            article.description!,
            style: descriptionStyle,
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
          ),
      ],
    );
  }
}
