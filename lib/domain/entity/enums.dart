/// Ticket status enumeration
enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}

/// Ticket priority levels
enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

/// Ticket categories/types
enum TicketCategory {
  technical,
  billing,
  general,
  account,
  other,
}

/// Ticket source/channel
enum TicketSource {
  messenger,
  zalo,
  email,
  phone,
  web,
}

/// Comment visibility type
enum CommentType {
  public,
  internal,
}

/// Extensions for display names
extension TicketStatusDisplay on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Mở';
      case TicketStatus.inProgress:
        return 'Đang xử lý';
      case TicketStatus.resolved:
        return 'Đã giải quyết';
      case TicketStatus.closed:
        return 'Đã đóng';
    }
  }

  String get englishName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }
}

extension TicketPriorityDisplay on TicketPriority {
  String get displayName {
    switch (this) {
      case TicketPriority.low:
        return 'Thấp';
      case TicketPriority.medium:
        return 'Trung bình';
      case TicketPriority.high:
        return 'Cao';
      case TicketPriority.urgent:
        return 'Khẩn cấp';
    }
  }

  String get englishName {
    switch (this) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.urgent:
        return 'Urgent';
    }
  }
}

extension TicketCategoryDisplay on TicketCategory {
  String get displayName {
    switch (this) {
      case TicketCategory.technical:
        return 'Kỹ thuật';
      case TicketCategory.billing:
        return 'Thanh toán';
      case TicketCategory.general:
        return 'Chung';
      case TicketCategory.account:
        return 'Tài khoản';
      case TicketCategory.other:
        return 'Khác';
    }
  }

  String get englishName {
    switch (this) {
      case TicketCategory.technical:
        return 'Technical';
      case TicketCategory.billing:
        return 'Billing';
      case TicketCategory.general:
        return 'General';
      case TicketCategory.account:
        return 'Account';
      case TicketCategory.other:
        return 'Other';
    }
  }
}

extension TicketSourceDisplay on TicketSource {
  String get displayName {
    switch (this) {
      case TicketSource.messenger:
        return 'Messenger';
      case TicketSource.zalo:
        return 'Zalo';
      case TicketSource.email:
        return 'Email';
      case TicketSource.phone:
        return 'Điện thoại';
      case TicketSource.web:
        return 'Website';
    }
  }
}

extension CommentTypeDisplay on CommentType {
  String get displayName {
    switch (this) {
      case CommentType.public:
        return 'Công khai';
      case CommentType.internal:
        return 'Nội bộ';
    }
  }

  String get englishName {
    switch (this) {
      case CommentType.public:
        return 'Public';
      case CommentType.internal:
        return 'Internal';
    }
  }
}
