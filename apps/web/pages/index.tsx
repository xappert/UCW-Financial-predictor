import { NextPage } from 'next';
import Head from 'next/head';
import Link from 'next/link';

const Home: NextPage = () => {
  return (
    <>
      <Head>
        <title>FinTrack - Personal Financial Analytics</title>
        <meta name="description" content="Transform your financial data into actionable insights" />
      </Head>

      {/* Hero Section */}
      <section className="bg-gradient-to-br from-indigo-600 to-indigo-800 text-white py-20">
        <div className="container-responsive text-center">
          <h1 className="text-h1 mb-6">
            Financial Insights Made Simple
          </h1>
          <p className="text-xl max-w-2xl mx-auto mb-10 opacity-90">
            Transform your financial data into actionable insights with our intuitive analytics platform
          </p>
          <div className="flex flex-col sm:flex-row justify-center gap-4">
            <Link href="/signup" passHref>
              <button className="btn-primary px-8 py-3 text-lg font-medium rounded-lg">
                Get Started Free
              </button>
            </Link>
            <Link href="/features" passHref>
              <button className="btn-secondary px-8 py-3 text-lg font-medium rounded-lg">
                Learn More
              </button>
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section - Centered content */}
      <section className="py-20 bg-slate-50 dark:bg-slate-900">
        <div className="container-responsive text-center">
          <div className="max-w-3xl mx-auto mb-16">
            <h2 className="text-h2 mb-4">
              Powerful Financial Analytics
            </h2>
            <p className="text-body text-slate-600 dark:text-slate-400">
              Our platform helps you understand your financial health with intuitive tools
            </p>
          </div>

          <div className="grid-responsive justify-center">
            {[
              {
                title: 'Budget Tracking',
                description: 'Monitor spending patterns and identify saving opportunities',
                icon: '💰'
              },
              {
                title: 'Investment Analysis',
                description: 'Evaluate portfolio performance with advanced visualizations',
                icon: '📈'
              },
              {
                title: 'Debt Management',
                description: 'Create payoff strategies and track progress',
                icon: '📉'
              },
              {
                title: 'Goal Planning',
                description: 'Set and achieve financial milestones',
                icon: '🎯'
              },
              {
                title: 'Risk Assessment',
                description: 'Understand your financial vulnerability factors',
                icon: '🛡️'
              },
              {
                title: 'Tax Optimization',
                description: 'Identify potential deductions and credits',
                icon: '🧾'
              }
            ].map((feature, index) => (
              <div key={index} className="card text-left">
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-h5 mb-2">{feature.title}</h3>
                <p className="text-body text-slate-600 dark:text-slate-400">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-indigo-50 dark:bg-slate-800">
        <div className="container-responsive text-center">
          <h2 className="text-h3 font-bold mb-6">Ready to take control of your finances?</h2>
          <p className="text-body max-w-2xl mx-auto mb-8 text-slate-700 dark:text-slate-300">
            Join thousands of users who have transformed their financial health
          </p>
          <Link href="/signup" passHref>
            <button className="btn-primary px-8 py-3 text-lg font-medium rounded-lg">
              Start Your Free Trial
            </button>
          </Link>
        </div>
      </section>
    </>
  );
};

export default Home;