import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/firestore.dart';
import 'package:portfolio/layout.dart';
import 'package:portfolio/theme.dart';
import 'package:portfolio/writing/article.dart';

class ArticleList extends StatefulWidget {
  /// A list of the available [Firestore.articles].
  ///
  /// The list is searchable using a [SearchBar] widget.
  const ArticleList({super.key});

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  /// The articles queried from Firestore,
  /// cached to avoid having to await [futureArticles] every time we rebuild.
  static List<Article>? articles;

  /// The articles that match the current [searchQuery].
  Iterable<Article>? get filteredArticles =>
      _ArticleListState.articles?.where((article) =>
          article.title.toLowerCase().contains(searchQuery) ||
          article.description?.toLowerCase().contains(searchQuery) == true);

  /// The controller for the search bar.
  final TextEditingController searchController = TextEditingController();

  /// The current search query that the user has entered.
  String get searchQuery => searchController.text.toLowerCase();

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSize.of(context);

    final bool isSinglePane =
        windowSize == WindowSize.compact || windowSize == WindowSize.medium;

    return SizedBox(
      width: switch (windowSize) {
        WindowSize.compact || WindowSize.medium => null,
        WindowSize.expanded || WindowSize.large => 360,
        WindowSize.extraLarge => 412,
      },
      child: Padding(
        padding: isSinglePane ? windowSize.margin : EdgeInsets.zero,
        child: Column(
          children: [
            if (isSinglePane) const SizedBox(height: 12),
            SearchBar(
              controller: searchController,
              elevation: WidgetStatePropertyAll(0),
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0),
              ),
              leading: Icon(Icons.search),
              hintText: "Search moments",
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
            ),
            const SizedBox(height: 12),
            Expanded(
              child: articles != null
                  ? _buildArticleList(context, filteredArticles!)
                  : FutureBuilder(
                      future: Firestore.articles
                          .orderBy("writtenAt", descending: true)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          debugPrint("[FIRESTORE] Error: ${snapshot.error}");
                          return SizedBox();
                        }
                        if (!snapshot.hasData) {
                          // TODO: Show placeholder during loading
                          return SizedBox();
                        }

                        _ArticleListState.articles = [
                          for (final doc in snapshot.data!.docs) doc.data()
                        ];

                        return _buildArticleList(context, filteredArticles!);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context, Iterable<Article> articles) {
    if (articles.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No moments found. Try a different search query.",
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: [
        for (final article in articles) _buildArticleTile(context, article),
      ],
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
            style: descriptionTextStyle(context),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        if (article.writtenAt != null)
          RichText(
            text: TextSpan(
              style: descriptionTextStyle(context),
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      Icons.event,
                      color: descriptionTextStyle(context)?.color,
                    ),
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
