import 'package:ai_helpdesk/domain/entity/marketing/marketing_broadcast.dart';
import 'package:ai_helpdesk/domain/usecase/marketing_broadcast/get_broadcast_recipients_usecase.dart';
import 'package:mobx/mobx.dart';

part 'audience_selection_store.g.dart';

class AudienceSelectionStore = _AudienceSelectionStoreBase
    with _$AudienceSelectionStore;

abstract class _AudienceSelectionStoreBase with Store {
  final GetBroadcastRecipientsUseCase _getRecipientsUseCase;

  _AudienceSelectionStoreBase(this._getRecipientsUseCase);

  @observable
  ObservableFuture<void> fetchFuture = ObservableFuture.value(null);

  @observable
  BroadcastPage<BroadcastRecipient>? recipientsPage;

  @observable
  String? errorMessage;

  @observable
  String? selectedSegmentValue;

  @observable
  String? selectedChannel;

  @observable
  ObservableList<String> selectedTags = ObservableList<String>();

  @observable
  int offset = 0;

  @observable
  int limit = 10;

  @computed
  bool get isLoading => fetchFuture.status == FutureStatus.pending;

  @computed
  int get recipientCount => recipientsPage?.total ?? 0;

  @computed
  bool get hasRecipients => recipientCount > 0;

  @computed
  bool get canProceedWithCampaign => hasRecipients && selectedSegmentValue != null;

  @action
  void setSegmentValue(String? value) {
    selectedSegmentValue = value;
    offset = 0;
  }

  @action
  void setChannel(String? value) {
    selectedChannel = value;
    offset = 0;
  }

  @action
  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
    offset = 0;
  }

  @action
  void clearFilters() {
    selectedSegmentValue = null;
    selectedChannel = null;
    selectedTags.clear();
    offset = 0;
  }

  @action
  Future<void> fetchRecipients({required String broadcastId}) async {
    errorMessage = null;
    final query = BroadcastRecipientsQuery(
      broadcastId: broadcastId,
      filter: BroadcastRecipientsFilter(
        segmentValue: selectedSegmentValue,
        channel: selectedChannel,
        tagValues: List<String>.from(selectedTags),
      ),
      offset: offset,
      limit: limit,
    );

    fetchFuture = ObservableFuture(
      _getRecipientsUseCase
          .call(params: GetBroadcastRecipientsParams(query: query))
          .then((page) {
        recipientsPage = page;
      }).catchError((e) {
        errorMessage = e.toString();
      }),
    );
    await fetchFuture;
  }

  @action
  Future<void> nextPage({required String broadcastId}) async {
    if (recipientsPage == null) return;
    final nextOffset = offset + limit;
    if (nextOffset < recipientsPage!.total) {
      offset = nextOffset;
      await fetchRecipients(broadcastId: broadcastId);
    }
  }

  @action
  Future<void> previousPage({required String broadcastId}) async {
    if (offset >= limit) {
      offset -= limit;
      await fetchRecipients(broadcastId: broadcastId);
    }
  }

  @action
  void clearError() {
    errorMessage = null;
  }
}
