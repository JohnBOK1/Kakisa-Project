import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'widgets/header.dart';
import 'screens/home_page.dart';
import 'screens/book_now_page.dart';
import 'screens/bookings_page.dart';
import 'screens/cart_page.dart';
import 'screens/about_us_page.dart';
import 'screens/contact_us_page.dart';
import 'screens/thank_you_page.dart';

void main() {
  runApp(const KakisaResortApp());
}

enum PageType { home, bookings, cart, bookNow, about, contact, thankYou }

class KakisaResortApp extends StatelessWidget {
  const KakisaResortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'KAKISA Dive Resort',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.black87,
          ),
        ),
        home: const MainApp(),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  PageType _currentPage = PageType.home;
  late AnimationController _pageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.easeInOut,
    ));

    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  void _navigateToPage(PageType page) {
    if (page != _currentPage) {
      _pageAnimationController.reset();
      setState(() {
        _currentPage = page;
      });
      _pageAnimationController.forward();
    }
  }

  Widget _buildCurrentPage() {
    final bookingProvider = context.watch<BookingProvider>();
    final cartProvider = context.watch<CartProvider>();

    switch (_currentPage) {
      case PageType.home:
        return HomePage(onNavigate: _navigateToPage);
      case PageType.bookings:
        return BookingsPage(
          bookings: bookingProvider.bookings, 
          onNavigate: _navigateToPage,
        );
      case PageType.cart:
        return CartPage(
          cartItems: cartProvider.items,
          onNavigate: _navigateToPage,
          onRemoveItem: cartProvider.removeItem,
          onClearCart: cartProvider.clearCart,
          onBookingComplete: (booking) {
            bookingProvider.addBooking(booking);
            cartProvider.clearCart();
            _navigateToPage(PageType.thankYou);
          },
        );
     case PageType.bookNow:
  return BookNowPage(
    onNavigate: _navigateToPage,
    onAddToCart: cartProvider.addItem,
    onBookingComplete: (booking) {
      bookingProvider.addBooking(booking);
      _navigateToPage(PageType.thankYou);
    },
    onClearCart: cartProvider.clearCart, // ✅ add this line
  );
      case PageType.about:
        return AboutUsPage(onNavigate: _navigateToPage);
      case PageType.contact:
        return ContactUsPage(onNavigate: _navigateToPage);
      case PageType.thankYou:
        return ThankYouPage(onNavigate: _navigateToPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFEFF6FF), // blue-50
              Color(0xFFECFEFF), // cyan-50
            ],
          ),
        ),
        child: Column(
          children: [
            Header(
              currentPage: _currentPage,
              onNavigate: _navigateToPage,
              cartItemCount: context.watch<CartProvider>().itemCount,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _pageAnimationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: _buildCurrentPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}