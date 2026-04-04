import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:ai_helpdesk/presentation/ticket/store/ticket_detail_store.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/comment_item_widget.dart';
import 'package:ai_helpdesk/presentation/ticket/widgets/detail/comment_input_widget.dart';

class CommentThreadWidget extends StatelessWidget {
  final TicketDetailStore store;

  const CommentThreadWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bình luận (${store.comments.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (store.comments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Chưa có bình luận nào',
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: store.comments.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) =>
                      CommentItemWidget(comment: store.comments[index]),
                ),
              const SizedBox(height: 16),
              CommentInputWidget(
                text: store.newCommentText,
                commentType: store.commentType,
                onTextChanged: store.setNewCommentText,
                onTypeChanged: store.setCommentType,
                onSend: store.addComment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
