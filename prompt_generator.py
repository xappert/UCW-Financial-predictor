def generate_prompt(loan_rate: float, investment_return: float, risk_tolerance: str) -> str:
    """
    Generates a detailed financial decision prompt for OpenAI API requests.
    
    Args:
        loan_rate: Annual loan interest rate (percentage value)
        investment_return: Expected annual investment return (percentage value)
        risk_tolerance: User's risk profile ('low', 'medium', or 'high')
    
    Returns:
        Formatted prompt string for OpenAI API
    
    Raises:
        ValueError: For invalid input parameters
    """
    # Validate numeric inputs
    if loan_rate <= 0:
        raise ValueError("Loan rate must be a positive number")
    if investment_return <= 0:
        raise ValueError("Investment return must be a positive number")
    
    # Validate risk tolerance
    valid_risks = ['low', 'medium', 'high']
    if risk_tolerance.lower() not in valid_risks:
        raise ValueError(f"Risk tolerance must be one of: {', '.join(valid_risks)}")
    
    # Construct the prompt
    return (
        f"Compare a loan interest rate of {loan_rate}% with an expected investment return of {investment_return}%. "
        f"Considering a {risk_tolerance} risk tolerance, should I prioritize investing or paying off debt?\n\n"
        "Provide:\n"
        "1. A clear recommendation (Invest/Pay off debt)\n"
        "2. Detailed reasoning with pros and cons\n"
        "3. Consideration of risk tolerance impact\n"
        "4. Balanced perspective comparing both options\n"
        "5. Any caveats or assumptions in your analysis"
    )