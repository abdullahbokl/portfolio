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
