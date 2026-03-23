abstract final class ProjectStrings {
  static const projectsSectionTitle = 'Engineered Systems';
  static const projectsSectionSubtitle =
      'Production-grade applications built with architectural intent';

  static const bokloTitle = 'Boklo Wallet';
  static const bokloSubtitle = 'High-Integrity Fintech System';
  static const bokloDescription =
      'A backend-authoritative wallet using Clean Architecture with strict '
      'separation of UI, Domain, and Data layers. Every transaction is safe, '
      'auditable, and idempotent.';
  static const bokloHighlights = [
    'Clean Architecture with strict UI / Domain / Data layer separation',
    'Append-only ledger as single source of truth — balances derived from backend ops',
    'Idempotent transfer execution — eliminates double-spending & race conditions',
    'Event-driven infrastructure via Cloud Functions & Eventarc',
    'Reactive UI via Cubit/Bloc for real-time updates without polling',
  ];
  static const bokloTech = [
    'Flutter',
    'Bloc',
    'Clean Architecture',
    'Firebase',
    'Cloud Functions',
  ];
  static const bokloImages = [
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/login_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/wallet_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/transfer_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/requests_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/notifications_list_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/notification_settings_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/profile_page.png',
    'https://raw.githubusercontent.com/abdullahbokl/Boklo-Wallet/main/docs/screenshots/personal_info_page.png',
  ];
  static const bokloGithubUrl = 'https://github.com/abdullahbokl/Boklo-Wallet';

  static const crmTitle = 'Smart CRM';
  static const crmSubtitle = 'Enterprise ERP & Field Management';
  static const crmDescription =
      'An enterprise-grade ERP for sales, marketing, and support operations. '
      'Led the architectural transition to N-layer Bloc for enterprise-level '
      'scalability.';
  static const crmHighlights = [
    'N-layer Bloc migration from Provider/MVVM for scalability',
    'Granular page-level privilege system for secure enterprise ops',
    'Google Maps integration for real-time field-visit coordination',
    'Local ID system enabling offline CRUD before server sync',
    'Doppler-secured secret management pipeline',
  ];
  static const crmTech = [
    'Flutter',
    'Bloc',
    'Google Maps',
    'REST API',
    'Doppler',
    'Shorebird',
  ];
  static const crmImages = [
    'https://media.licdn.com/dms/image/v2/D4D2DAQHB97t1mZipWA/profile-treasury-image-shrink_800_800/B4DZzVC8yqH4AY-/0/1773100847132?e=1774908000&v=beta&t=UmZt1aMY4JKQ6lNclYM-JWJosWlGzqPHSdSMYbRGf0g',
    'https://media.licdn.com/dms/image/v2/D4D2DAQFY4nk6pKhPqg/profile-treasury-image-shrink_800_800/B4DZzVC8ypHEAY-/0/1773100847288?e=1774908000&v=beta&t=IcxyRfXROjh79UPBJsLhG-gno0j8SocBGZiY55kOS3k',
    'https://media.licdn.com/dms/image/v2/D4D2DAQHiy1X-UbT0kg/profile-treasury-image-shrink_800_800/B4DZzVC8ypJoAY-/0/1773100847326?e=1774908000&v=beta&t=Lz8q2JJfmJAbMxaRfyjCI_smLOfY-KPIYMkbHRLaLWY',
    'https://media.licdn.com/dms/image/v2/D4D2DAQEN63D5kptnoQ/profile-treasury-image-shrink_800_800/B4DZzVC8ypKoAc-/0/1773100847139?e=1774908000&v=beta&t=sHZ4c6Ms1YbhKsydYal1S07ar8w6KJEVViapFXn9UOk',
    'https://media.licdn.com/dms/image/v2/D4D2DAQFPUtJS9ZtIMQ/profile-treasury-image-shrink_800_800/B4DZzVC8yoIAAc-/0/1773100847154?e=1774908000&v=beta&t=B9AlE7xyOauqfrHiIY904RDowlWSe0GSB3jniiFX9wk',
    'https://media.licdn.com/dms/image/v2/D4D2DAQEY0HBzYOhC4w/profile-treasury-image-shrink_800_800/B4DZzVC8yoHwAc-/0/1773100847428?e=1774908000&v=beta&t=vi9m52eoLSaZ-dneYl120Qb3u727opeH9Rd_zDVOApc',
    'https://media.licdn.com/dms/image/v2/D4D2DAQERHydkHwT4uQ/profile-treasury-image-shrink_800_800/B4DZzVC8y0KYAY-/0/1773100846669?e=1774908000&v=beta&t=g1enejX8qrDGKiagFexADSYB6UbeZRwt7tkcmPObaxE',
  ];
  static const crmPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.mpluse.crmsmart';
  static const crmAppleStoreUrl =
      'https://apps.apple.com/us/app/smart-crm/id6451082072';

  static const kiranaTitle = 'Billing Fast';
  static const kiranaSubtitle = 'Scalable Inventory Suite';
  static const kiranaDescription =
      'A high-scale inventory management suite for international markets. '
      'Engineered complex batch-based stock tracking with multi-tier pricing '
      'and real-time Firebase synchronization.';
  static const kiranaHighlights = [
    'Batch System for products across multiple arrival dates & prices',
    'Multi-tier pricing engine (Wholesale → Retail → VIP Loyalty)',
    'Real-time inventory management via Firebase for international markets',
    'High-precision Google Maps tracking for order coordination',
    'Offline queue with automatic retry on reconnect',
  ];
  static const kiranaTech = [
    'Flutter',
    'Firebase',
    'Cloud Functions',
    'Google Maps',
  ];
  static const kiranaImages = [
    'https://media.licdn.com/dms/image/v2/D4D2DAQE7XBIqNol4Zw/profile-treasury-image-shrink_480_480/B4DZzVBWT6JIAM-/0/1773100427576?e=1774908000&v=beta&t=jW28MLyKwkucu3YijDmm7XfEy0Ljt10IBpfiKyfm_NY',
    'https://media.licdn.com/dms/image/v2/D4D2DAQGrDmceUpMC_w/profile-treasury-image-shrink_800_800/B4DZzVBWT6JIBM-/0/1773100428369?e=1774908000&v=beta&t=rvCIHHDmGrZqv-ifvOn3De5ynYcw9O8L1TmNnibAT5A',
    'https://media.licdn.com/dms/image/v2/D4D2DAQFa1FmiGMNRXg/profile-treasury-image-shrink_800_800/B4DZzVBWT9HYAY-/0/1773100428370?e=1774908000&v=beta&t=hvwcfO-M7udZK9NPPDgAps9K9HsNFBQijaXsXMLRDnw',
    'https://media.licdn.com/dms/image/v2/D4D2DAQEF_bdMFZDvmA/profile-treasury-image-shrink_800_800/B4DZzVBWT8HIAY-/0/1773100428246?e=1774908000&v=beta&t=DxZSGjDDEYLigRQb3Pbm59PLcr-fF-auOhW9efRmxzY',
    'https://media.licdn.com/dms/image/v2/D4D2DAQHMguRY9BAb-Q/profile-treasury-image-shrink_800_800/B4DZzVBWT9GwAY-/0/1773100428419?e=1774908000&v=beta&t=eV4F_319N5KwOkKFQgPL_J8wkoxI0iiB2-qkiQq2iKQ',
    'https://media.licdn.com/dms/image/v2/D4D2DAQHRCyKEjwfFlQ/profile-treasury-image-shrink_800_800/B4DZzVBWT_I4AY-/0/1773100428055?e=1774908000&v=beta&t=8pVz6neLKPTPglxoPWvbU1OrSpqSgsQeC4rSMAYCE80',
  ];
  static const kiranaPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.apnidukan.my_app';
  static const kiranaAppleStoreUrl =
      'https://apps.apple.com/in/app/billing-fast-kirana-fast/id1567324958';
  static const kiranaWebUrl = 'https://billingfast.com/app/#/initCompany';
  static const kiranaWebsiteUrl = 'https://billingfast.com/';

  static const jobHubTitle = 'Job-Hub';
  static const jobHubSubtitle = 'Full-Stack Ecosystem';
  static const jobHubDescription =
      'A real-time full-stack application built with Node.js, Express, and '
      'MongoDB. Features JWT-based authentication and real-time chat for '
      'recruiter-candidate interaction.';
  static const jobHubHighlights = [
    'Full-stack infrastructure: Flutter + Node.js + Express + MongoDB',
    'Real-time chat system via Socket.io for instant communication',
    'JWT-based authentication securing user data & recruiter access',
  ];
  static const jobHubTech = [
    'Flutter',
    'Node.js',
    'Express',
    'MongoDB',
    'Socket.io',
    'JWT',
  ];
  static const jobHubImages = [
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/splash-screen.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/onboarding-discovery.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/role-selection.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/login-screen.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/job-listings.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/job-search-filters.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/company-dashboard.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/post-job-form.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/my-posted-jobs.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/my-applications-tracker.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/chat-interface.jpg',
    'https://raw.githubusercontent.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App/main/docs/screenshots/profile-overview.jpg',
  ];
  static const jobHubGithubUrl =
      'https://github.com/abdullahbokl/Flutter-NodeJS-Full-Stack-App';

  static const netflixTitle = 'Netflix Clone';
  static const netflixSubtitle = 'Native iOS Engineering';
  static const netflixDescription =
      'A high-fidelity native iOS application built with Swift and UIKit, '
      'focused on native performance, dynamic API content, and offline '
      'metadata access.';
  static const netflixHighlights = [
    'Native Swift & UIKit for high-performance rendering',
    'Dynamic content from integrated REST APIs',
    'Optimized local storage for favorites & offline metadata',
  ];
  static const netflixTech = ['Swift', 'UIKit', 'REST API', 'Local Storage'];
  static const netflixGithubUrl =
      'https://github.com/abdullahbokl/MoviesApp-iOS';
}
