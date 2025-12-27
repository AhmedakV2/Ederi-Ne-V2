import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/data_controller.dart'; 
import '../following/following_list_screen.dart';
import '../navigation/main_navigation.dart';
import '../../core/theme/app_theme.dart';
import '../auth/splash_screen.dart'; 

// Widget Importları
import 'widgets/edit_product_sheet.dart'; 
import 'widgets/profile_header_content.dart';
import 'widgets/profile_tabs.dart';
import 'widgets/edit_profile_sheet.dart';

class ProfileScreen extends StatefulWidget {
  final String? targetUserId; 

  const ProfileScreen({super.key, this.targetUserId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final db = DataController(); 

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- PROFİL GÜNCELLEME VE SENKRONİZASYON ---
  void _updateProfileAndProducts(String name, String bio, String avatar, String? storeName, String? city, String? district) async {
    if (currentUser == null) return;

    try {
      // 1. Kullanıcı Profilini Güncelle
      await usersRef.doc(currentUser!.uid).update({
        'name': name,
        'bio': bio,
        'avatar': avatar,
        'storeName': storeName,
        'city': city,
        'district': district,
      });

      // 2. BU KULLANICININ TÜM ÜRÜNLERİNİ BUL VE GÜNCELLE (Batch Update)
      var userProducts = await productsRef.where('ownerId', isEqualTo: currentUser!.uid).get();
      
      var batch = FirebaseFirestore.instance.batch();
      
      for (var doc in userProducts.docs) {
        batch.update(doc.reference, {
          'addedBy': (storeName != null && storeName.isNotEmpty) ? storeName : name,
          'userAvatar': avatar,
          'market': (storeName != null && storeName.isNotEmpty) ? storeName : doc['market'],
        });
      }

      await batch.commit(); 

      // 3. Hafızayı Yenile
      await db.loadUserData();
      
      // Asenkron işlem sonrası mounted kontrolü
      if (!mounted) return;
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil ve tüm ürünler güncellendi!"), backgroundColor: Colors.green),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  // --- TAKİP SİSTEMİ ---
  Future<void> _toggleFollow(String targetUserId, List<dynamic> currentFollowers) async {
    if (currentUser == null) return;
    final bool isFollowing = currentFollowers.contains(currentUser!.uid);

    try {
      if (isFollowing) {
        await usersRef.doc(targetUserId).update({'followers': FieldValue.arrayRemove([currentUser!.uid])});
        await usersRef.doc(currentUser!.uid).update({'following': FieldValue.arrayRemove([targetUserId])});
        db.followingIds.remove(targetUserId);
      } else {
        await usersRef.doc(targetUserId).update({'followers': FieldValue.arrayUnion([currentUser!.uid])});
        await usersRef.doc(currentUser!.uid).update({'following': FieldValue.arrayUnion([targetUserId])});
        db.followingIds.add(targetUserId);
      }
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // --- ÇIKIŞ YAP ---
  void _handleLogout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Çıkış", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', false);
    await FirebaseAuth.instance.signOut();
    DataController().clearSession();
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => const SplashScreen()), (r) => false);
    }
  }

  // --- ÜRÜN İŞLEMLERİ ---
  void _deleteProduct(String productId) async {
    try {
      await productsRef.doc(productId).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Silindi")));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  void _editProduct(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      backgroundColor: Colors.transparent,
      builder: (context) {
        return EditProductSheet(
          currentItem: item,
          onSave: (newName, newPrice, newMarket) async {
            await productsRef.doc(item['id']).update({
              'name': newName, 'price': newPrice, 'market': newMarket
            });
            if (mounted) setState(() {}); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayUserId = widget.targetUserId ?? currentUser!.uid;
    final bool isMyProfile = displayUserId == currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: usersRef.doc(displayUserId).snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const Scaffold(body: Center(child: Text("Kullanıcı bulunamadı")));
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        String name = userData['name'] ?? "İsimsiz";
        String role = userData['role'] ?? "Müşteri";
        String bio = userData['bio'] ?? "";
        String avatarPath = userData['avatar'] ?? "assets/images/avatar_1.png";
        String? storeName = userData['storeName'];
        
        String displayName = (role == "Satıcı" && storeName != null) ? storeName : name;

        return StreamBuilder<QuerySnapshot>(
          stream: productsRef.where('ownerId', isEqualTo: displayUserId).snapshots(),
          builder: (context, productSnapshot) {
            final List<Map<String, dynamic>> userProducts = [];
            final List<double> ratingHistory = []; 
            double totalRating = 0;

            if (productSnapshot.hasData) {
              for (var doc in productSnapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id; 
                userProducts.add(data);
                
                double r = 0.0;
                if (data['rating'] != null) {
                  r = (data['rating'] as num).toDouble();
                }
                totalRating += r;
                if (r > 0) ratingHistory.add(r);
              }
            }
            
            double averageRating = userProducts.isNotEmpty ? totalRating / userProducts.length : 0.0;

            return Scaffold(
              backgroundColor: AppTheme.background,
              body: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    expandedHeight: 520,
                    pinned: true,
                    backgroundColor: AppTheme.navyDark,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) =>  MainNavigation()));
                        }
                      },
                    ),
                    actions: [
                      if (isMyProfile) ...[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _showEditProfileDialog(userData),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.redAccent),
                          onPressed: _handleLogout,
                        ),
                      ]
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeaderContent(
                        displayName: displayName,
                        avatarPath: avatarPath,
                        isTargetSeller: role == "Satıcı",
                        isMyProfile: isMyProfile,
                        followerCount: (userData['followers'] as List?)?.length ?? 0, 
                        followingCount: (userData['following'] as List?)?.length ?? 0,
                        productCount: userProducts.length,
                        rating: averageRating,
                        onFollowersTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FollowingListScreen()));
                        },
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(60),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.background, 
                          borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppTheme.accentGold),
                          labelColor: AppTheme.navyDark,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: const [Tab(text: "Hakkında"), Tab(text: "Paylaşımlar")],
                        ),
                      ),
                    ),
                  )
                ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    ProfileAboutTab(
                      bio: bio,
                      isMyProfile: isMyProfile,
                      isTargetSeller: role == "Satıcı",
                      amIFollowing: (userData['followers'] as List?)?.contains(currentUser?.uid) ?? false,
                      displayProducts: userProducts,
                      ratingHistory: ratingHistory.isNotEmpty ? ratingHistory : [0.0],
                      onFollowToggle: () => _toggleFollow(displayUserId, (userData['followers'] as List?) ?? []),
                    ),
                    ProfilePostsTab(
                      displayProducts: userProducts,
                      isMyProfile: isMyProfile,
                      onEdit: (item) => _editProduct(item),
                      onDelete: (item) => _deleteProduct(item['id']),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showEditProfileDialog(Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return EditProfileSheet(
          currentName: userData['name'] ?? "",
          currentBio: userData['bio'] ?? "",
          currentAvatar: userData['avatar'] ?? "assets/images/avatar_1.png",
          currentStoreName: userData['storeName'],
          currentCity: userData['city'],
          currentDistrict: userData['district'],
          avatars: const ['assets/images/avatar_1.png', 'assets/images/avatar_2.png'],
          onSave: (name, bio, avatar, storeName, city, district) {
            _updateProfileAndProducts(name, bio, avatar, storeName, city, district);
          },
        );
      },
    );
  }
}