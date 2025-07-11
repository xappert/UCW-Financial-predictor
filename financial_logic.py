def compare_rates(loan_rate: float, investment_return: float, risk_tolerance: str) -> dict:
    """
    Compares loan interest rate against expected investment return and provides
    a recommendation based on risk tolerance.
    
    Args:
        loan_rate: Annual loan interest rate as percentage (e.g., 4.5 for 4.5%)
        investment_return: Expected annual investment return as percentage
        risk_tolerance: User's risk profile ('high', 'medium', or 'low')
    
    Returns:
        Dictionary with:
        - 'decision': Recommendation ('Invest' or 'Pay off debt')
        - 'reason': Detailed explanation of recommendation
    
    Raises:
        ValueError: If inputs are invalid
    """
    # Validate inputs
    if not isinstance(loan_rate, (int, float)) or loan_rate < 0:
        raise ValueError("Loan rate must be a non-negative number")
    if not isinstance(investment_return, (int, float)) or investment_return < 0:
        raise ValueError("Investment return must be a non-negative number")
    if risk_tolerance.lower() not in ['high', 'medium', 'low']:
        raise ValueError("Risk tolerance must be 'high', 'medium', or 'low'")
    
    # Normalize risk tolerance
    risk_tolerance = risk_tolerance.lower()
    
    # Core decision logic
    if investment_return > loan_rate:
        decision = "Invest"
        base_reason = (f"Your expected investment return ({investment_return}%) "
                      f"is higher than your loan interest rate ({loan_rate}%).")
    else:
        decision = "Pay off debt"
        base_reason = (f"Your loan interest rate ({loan_rate}%) is higher than "
                       f"your expected investment return ({investment_return}%).")
    
    # Risk-adjusted reasoning
    risk_perspective = ""
    if decision == "Invest":
        if risk_tolerance == 'high':
            risk_perspective = ("Since you have high risk tolerance, investing makes sense "
                                "as you can withstand potential market volatility.")
        elif risk_tolerance == 'medium':
            risk_perspective = ("With medium risk tolerance, consider diversifying investments "
                                "while maintaining some debt payments.")
        else:  # low risk tolerance
            risk_perspective = ("Despite the potential returns, your low risk tolerance suggests "
                                "prioritizing debt reduction for guaranteed savings.")
        
        pros_cons = ("Potential pros: Higher long-term returns. "
                     "Potential cons: Market risks could erode gains.")
    
    else:  # Pay off debt decision
        if risk_tolerance == 'high':
            risk_perspective = ("Even with high risk tolerance, paying off high-interest debt "
                                "provides a guaranteed return equivalent to the loan rate.")
        elif risk_tolerance == 'medium':
            risk_perspective = ("With medium risk tolerance, reducing debt provides "
                                "a balanced approach to financial security.")
        else:  # low risk tolerance
            risk_perspective = ("Your low risk tolerance makes debt reduction the optimal choice "
                                "for guaranteed financial improvement.")
        
        pros_cons = ("Potential pros: Guaranteed savings, reduced financial stress. "
                     "Potential cons: Might miss out on exceptional market gains.")
    
    # Construct final reason
    reason = f"{base_reason} {risk_perspective} {pros_cons}"
    
    return {
        "decision": decision,
        "reason": reason
    }