import Head from 'next/head';
import FinancialPredictor from '@/components/analysis/FinancialPredictor';

export default function Home() {
  const scrollToPredictor = () => {
    document.getElementById('financial-predictor')?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <>
      <Head>
        <title>Financial Predictor | UCW</title>
      </Head>
      
      <div className="min-h-screen bg-slate-50 dark:bg-slate-900">
        {/* Hero Section */}
        <section className="bg-gradient-to-r from-blue-600 to-indigo-700 text-white py-20">
          <div className="container mx-auto text-center px-4">
            <h1 className="text-4xl md:text-5xl font-bold mb-4">AI-Powered Financial Predictions</h1>
            <p className="text-xl mb-8 max-w-2xl mx-auto">
              Leverage advanced machine learning to forecast market trends and make data-driven investment decisions
            </p>
            <div className="flex flex-col sm:flex-row justify-center gap-4">
              <button
                onClick={scrollToPredictor}
                className="bg-white text-blue-600 hover:bg-blue-50 font-bold py-3 px-6 rounded-lg transition duration-300"
              >
                Get started free
              </button>
              <button
                onClick={scrollToPredictor}
                className="bg-transparent border-2 border-white hover:bg-white/10 font-bold py-3 px-6 rounded-lg transition duration-300"
              >
                Start your free trial
              </button>
            </div>
          </div>
        </section>

        {/* Main Content */}
        <main className="container mx-auto py-16 px-4">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold mb-4">How It Works</h2>
            <p className="text-lg text-slate-600 dark:text-slate-300 max-w-3xl mx-auto">
              Our AI analyzes historical data and market trends to provide accurate financial predictions
            </p>
          </div>
          
          <div id="financial-predictor" className="mb-16">
            <h2 className="text-3xl font-bold mb-6 text-center">Financial Predictor</h2>
            <FinancialPredictor />
          </div>

          <div className="bg-white dark:bg-slate-800 rounded-xl shadow-lg p-8 max-w-4xl mx-auto">
            <h3 className="text-2xl font-bold mb-4">Ready to get started?</h3>
            <p className="mb-6">Join thousands of investors using our AI-powered prediction tools</p>
            <button
              onClick={scrollToPredictor}
              className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-8 rounded-lg transition duration-300"
            >
              Start Predicting Now
            </button>
          </div>
        </main>
      </div>
    </>
  );
}