class OrderHistoryItem {
  const OrderHistoryItem({
    required this.id,
    required this.dateLabel,
    required this.itemCount,
    required this.total,
    required this.status,
  });
  final String id;
  final String dateLabel;
  final int itemCount;
  final double total;
  final String status;
}
class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
    required this.orders,
  });
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;
  final List<OrderHistoryItem> orders;
  UserProfile copyWith({String? name}) {
    return UserProfile(
      name: name ?? this.name,
      email: email,
      phone: phone,
      address: address,
      avatarUrl: avatarUrl,
      orders: orders,
    );
  }
  static UserProfile mock() {
    return const UserProfile(
      name: 'Afi Mensah',
      email: 'afi.mensah@togoshop.tg',
      phone: '+228 90 12 34 56',
      address: 'Rue des Palmiers, Tokoin, Lomé, Togo',
      avatarUrl:
          'https://images.unsplash.com/photo-1531123897727-8f89b6d6f2d0?auto=format&fit=crop&w=400&q=80',
      orders: [
        OrderHistoryItem(
          id: 'CMD-1042',
          dateLabel: '12 août 2026',
          itemCount: 3,
          total: 28900,
          status: 'Livrée',
        ),
        OrderHistoryItem(
          id: 'CMD-1038',
          dateLabel: '28 juillet 2026',
          itemCount: 1,
          total: 12500,
          status: 'Livrée',
        ),
        OrderHistoryItem(
          id: 'CMD-1021',
          dateLabel: '3 juillet 2026',
          itemCount: 5,
          total: 41200,
          status: 'Annulée',
        ),
      ],
    );
  }
}