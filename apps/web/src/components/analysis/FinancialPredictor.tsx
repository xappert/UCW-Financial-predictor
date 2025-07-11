import { useState } from 'react';

export default function FinancialPredictor() {
  const [input, setInput] = useState('');
  const [prediction, setPrediction] = useState('');

  const handlePredict = () => {
    // Placeholder prediction logic
    setPrediction(`Predicted trend for "${input}"`);
  };

  return (
    <div className="bg-white dark:bg-slate-800 rounded-lg shadow p-6">
      <div className="mb-4">
        <label htmlFor="financialInput" className="block text-sm font-medium mb-1">
          Enter financial data
        </label>
        <textarea
          id="financialInput"
          className="w-full p-2 border rounded"
          rows={4}
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Paste financial statements or market data..."
        />
      </div>
      
      <button 
        onClick={handlePredict}
        className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded"
      >
        Analyze and Predict
      </button>

      {prediction && (
        <div className="mt-4 p-4 bg-slate-100 dark:bg-slate-700 rounded">
          <h3 className="font-bold mb-2">Prediction Result:</h3>
          <p>{prediction}</p>
        </div>
      )}
    </div>
  );
}