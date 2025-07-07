// Common type definitions for the UCW Financial Predictor application

export interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  phone?: string;
  subscriptionStatus: SubscriptionStatus;
  trialEndDate?: Date;
  subscriptionEndDate?: Date;
  isActive: boolean;
  emailVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
  lastLogin?: Date;
}

export enum SubscriptionStatus {
  TRIAL = 'trial',
  ACTIVE = 'active',
  CANCELLED = 'cancelled',
  EXPIRED = 'expired',
}

export interface FinancialProfile {
  id: string;
  userId: string;
  netMonthlyIncome?: number;
  grossMonthlyIncome?: number;
  fixedMonthlyExpenses?: number;
  variableMonthlyExpenses?: number;
  currentSavings?: number;
  emergencyFund?: number;
  extraCashAvailable?: number;
  riskTolerance?: RiskTolerance;
  investmentHorizonYears?: number;
  investmentExperience?: InvestmentExperience;
  financialGoals?: FinancialGoal[];
  spendingHabits?: Record<string, any>;
  age?: number;
  maritalStatus?: string;
  dependents?: number;
  employmentStatus?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum RiskTolerance {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
}

export enum InvestmentExperience {
  BEGINNER = 'beginner',
  INTERMEDIATE = 'intermediate',
  ADVANCED = 'advanced',
}

export interface FinancialGoal {
  id: string;
  description: string;
  targetAmount: number;
  targetDate: Date;
  priority: 'low' | 'medium' | 'high';
  category: string;
}

export interface Loan {
  id: string;
  userId: string;
  loanType: LoanType;
  name: string;
  lender?: string;
  originalAmount: number;
  currentBalance: number;
  interestRate: number;
  minimumMonthlyPayment: number;
  termYears: number;
  remainingPayments?: number;
  nextPaymentDate?: Date;
  maturityDate?: Date;
  totalPaid?: number;
  interestPaid?: number;
  principalPaid?: number;
  isActive: boolean;
  isDelinquent?: boolean;
  priorityScore?: number;
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export enum LoanType {
  STUDENT = 'student',
  CAR = 'car',
  MORTGAGE = 'mortgage',
  PERSONAL = 'personal',
  CREDIT_CARD = 'credit_card',
  BUSINESS = 'business',
  HOME_EQUITY = 'home_equity',
}

export interface Investment {
  id: string;
  userId: string;
  investmentType: InvestmentType;
  name: string;
  symbol?: string;
  currentValue: number;
  initialInvestment?: number;
  expectedAnnualReturn: number;
  actualAnnualReturn?: number;
  riskLevel: RiskLevel;
  purchaseDate: Date;
  monthlyContribution?: number;
  dividendYield?: number;
  isTaxAdvantaged?: boolean;
  taxAccountType?: string;
  isActive: boolean;
  isMonitored: boolean;
  notes?: string;
  assetAllocation?: Record<string, number>;
  createdAt: Date;
  updatedAt: Date;
}

export enum InvestmentType {
  STOCKS = 'stocks',
  BONDS = 'bonds',
  MUTUAL_FUNDS = 'mutual_funds',
  ETF = 'etf',
  SAVINGS = 'savings',
  REAL_ESTATE = 'real_estate',
  CRYPTOCURRENCY = 'cryptocurrency',
  COMMODITIES = 'commodities',
}

export enum RiskLevel {
  LOW = 'low',
  MEDIUM = 'medium',
  HIGH = 'high',
}

export interface Recommendation {
  id: string;
  userId: string;
  scenarioType: string;
  decision: RecommendationDecision;
  confidenceScore: number;
  primaryReason: string;
  detailedExplanation: string;
  pros: string[];
  cons: string[];
  keyMetrics: Record<string, any>;
  scenariosAnalyzed: Record<string, any>;
  inputParameters: Record<string, any>;
  recommendedActions: RecommendedAction[];
  modelVersion?: string;
  modelType?: string;
  processingTimeMs?: number;
  status: 'active' | 'archived' | 'implemented';
  userFeedback?: Record<string, any>;
  implementationStatus?: string;
  createdAt: Date;
  expiresAt?: Date;
}

export enum RecommendationDecision {
  PRIORITIZE_LOANS = 'prioritize_loans',
  PRIORITIZE_INVESTMENTS = 'prioritize_investments',
  HYBRID_APPROACH = 'hybrid_approach',
  INSUFFICIENT_DATA = 'insufficient_data',
}

export interface RecommendedAction {
  action: 'allocate_to_loans' | 'allocate_to_investments' | 'emergency_fund' | 'other';
  percentage: number;
  amount: number;
  reasoning: string;
  priority?: number;
}

export interface MarketData {
  primeRate?: number;
  federalFundsRate?: number;
  inflationRate?: number;
  treasuryRates?: Record<string, number>;
  marketIndices?: Record<string, MarketIndex>;
  mortgageRates?: Record<string, number>;
  economicIndicators?: Record<string, number>;
  commodityPrices?: Record<string, CommodityPrice>;
  currencyExchange?: Record<string, number>;
  lastUpdated: Date;
  marketStatus: 'open' | 'closed' | 'pre_market' | 'after_hours';
  nextMarketClose?: Date;
}

export interface MarketIndex {
  currentValue: number;
  changePercent: number;
  changeValue: number;
  ytdReturn: number;
  weekHigh52: number;
  weekLow52: number;
}

export interface CommodityPrice {
  pricePerUnit: number;
  changePercent: number;
  currency: string;
  unit?: string;
}

// Analysis Input Types
export interface AnalysisInput {
  basicInfo: BasicInfo;
  financialProfile: Partial<FinancialProfile>;
  loans: Partial<Loan>[];
  investments: Partial<Investment>[];
  goals: FinancialGoal[];
  extraCashAmount: number;
  analysisType: 'quick' | 'detailed';
  customParameters?: Record<string, any>;
}

export interface BasicInfo {
  firstName: string;
  lastName: string;
  age: number;
  employmentStatus: string;
  maritalStatus: string;
  dependents: number;
}

// API Response Types
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// UI Component Types
export interface SelectOption {
  value: string | number;
  label: string;
  disabled?: boolean;
}

export interface FormFieldError {
  field: string;
  message: string;
}

export interface ToastNotification {
  id: string;
  type: 'success' | 'error' | 'warning' | 'info';
  title: string;
  message?: string;
  duration?: number;
  dismissible?: boolean;
}

// Wizard/Stepper Types
export interface WizardStep {
  id: string;
  title: string;
  description?: string;
  isComplete: boolean;
  isActive: boolean;
  isOptional?: boolean;
}

// Chart Data Types
export interface ChartDataPoint {
  x: number | string | Date;
  y: number;
  label?: string;
  color?: string;
}

export interface ChartSeries {
  name: string;
  data: ChartDataPoint[];
  color?: string;
  type?: 'line' | 'bar' | 'area' | 'pie';
}

export interface ChartConfig {
  title?: string;
  xAxisLabel?: string;
  yAxisLabel?: string;
  showLegend?: boolean;
  showGrid?: boolean;
  responsive?: boolean;
  height?: number;
  width?: number;
}

// Subscription and Billing Types
export interface Subscription {
  id: string;
  userId: string;
  planType: PlanType;
  status: SubscriptionStatus;
  billingCycle: 'monthly' | 'annual';
  amount: number;
  currency: string;
  stripeSubscriptionId?: string;
  stripePriceId?: string;
  currentPeriodStart?: Date;
  currentPeriodEnd?: Date;
  trialStart?: Date;
  trialEnd?: Date;
  cancelAtPeriodEnd?: boolean;
  cancelledAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export enum PlanType {
  BASIC = 'basic',
  PREMIUM = 'premium',
}

// Event Types for Analytics
export interface AnalyticsEvent {
  event: string;
  userId?: string;
  properties?: Record<string, any>;
  timestamp?: Date;
}

// Error Types
export interface AppError extends Error {
  code?: string;
  statusCode?: number;
  details?: any;
}

// Navigation Types
export interface NavigationItem {
  id: string;
  label: string;
  href: string;
  icon?: string;
  isActive?: boolean;
  badge?: string | number;
  children?: NavigationItem[];
}

// Feature Flag Types
export interface FeatureFlag {
  key: string;
  enabled: boolean;
  description?: string;
  rolloutPercentage?: number;
}