import 'package:flutter/material.dart';

/// Ticket status enumeration
enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
  pending,
  processingByAI,
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

/// Contact type for ticket
enum ContactType {
  email,
  phone,
  zalo,
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
      case TicketStatus.pending:
        return 'Đang chờ';
      case TicketStatus.processingByAI:
        return 'Đang xử lý bởi AI';
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
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.processingByAI:
        return 'Processing by AI';
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

extension ContactTypeDisplay on ContactType {
  String get displayName {
    switch (this) {
      case ContactType.email:
        return 'Email';
      case ContactType.phone:
        return 'Điện thoại';
      case ContactType.zalo:
        return 'Zalo';
    }
  }

  IconData get iconData {
    switch (this) {
      case ContactType.email:
        return Icons.email;
      case ContactType.phone:
        return Icons.phone;
      case ContactType.zalo:
        return Icons.message;
    }
  }

  Color get iconColor {
    switch (this) {
      case ContactType.email:
        return const Color(0xFFD32F2F); // Red for email
      case ContactType.phone:
        return const Color(0xFF388E3C); // Green for phone
      case ContactType.zalo:
        return const Color(0xFF0084FF); // Blue for Zalo
    }
  }

  String get hintText {
    switch (this) {
      case ContactType.email:
        return 'Nhập email của khách hàng';
      case ContactType.phone:
        return 'Nhập số điện thoại của khách hàng';
      case ContactType.zalo:
        return 'Nhập ID Zalo của khách hàng';
    }
  }
}
