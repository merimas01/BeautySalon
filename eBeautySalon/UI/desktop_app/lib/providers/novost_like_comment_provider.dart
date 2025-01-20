import 'package:desktop_app/models/novost_like_comment.dart';

import 'base_provider.dart';

class NovostLikeCommentProvider extends BaseProvider<NovostLikeComment> {
  NovostLikeCommentProvider() : super("NovostiLikeComment", "");

  @override
  NovostLikeComment fromJson(data) {
    // TODO: implement fromJson
    return NovostLikeComment.fromJson(data);
  }
}
