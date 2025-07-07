import React, { forwardRef } from 'react';
import { clsx } from 'clsx';

export interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: 'default' | 'outlined' | 'elevated' | 'filled';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  hover?: boolean;
  interactive?: boolean;
}

export interface CardHeaderProps extends React.HTMLAttributes<HTMLDivElement> {
  divider?: boolean;
}

export interface CardContentProps extends React.HTMLAttributes<HTMLDivElement> {
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
}

export interface CardFooterProps extends React.HTMLAttributes<HTMLDivElement> {
  divider?: boolean;
  background?: 'default' | 'muted';
}

const Card = forwardRef<HTMLDivElement, CardProps>(
  (
    {
      className,
      variant = 'default',
      padding = 'md',
      hover = false,
      interactive = false,
      children,
      onClick,
      ...props
    },
    ref
  ) => {
    const baseClasses = clsx(
      // Base styles
      'rounded-lg overflow-hidden transition-all duration-200',
      
      // Variant styles
      {
        // Default card with subtle shadow
        'bg-white border border-gray-200 shadow-sm': variant === 'default',
        
        // Outlined card with border only
        'bg-white border border-gray-300': variant === 'outlined',
        
        // Elevated card with larger shadow
        'bg-white border border-gray-200 shadow-lg': variant === 'elevated',
        
        // Filled card with background
        'bg-gray-50 border border-gray-200': variant === 'filled',
      },

      // Padding styles
      {
        'p-0': padding === 'none',
        'p-3': padding === 'sm',
        'p-4': padding === 'md',
        'p-6': padding === 'lg',
        'p-8': padding === 'xl',
      },

      // Interactive states
      {
        'hover:shadow-md': hover && variant !== 'elevated',
        'hover:shadow-xl': hover && variant === 'elevated',
        'cursor-pointer': interactive,
        'hover:border-gray-300': interactive && variant === 'outlined',
        'focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2': interactive,
      },

      className
    );

    if (interactive && onClick) {
      return (
        <div
          ref={ref}
          className={baseClasses}
          onClick={onClick}
          onKeyDown={(e) => {
            if (e.key === 'Enter' || e.key === ' ') {
              e.preventDefault();
              onClick?.(e as any);
            }
          }}
          role="button"
          tabIndex={0}
          {...props}
        >
          {children}
        </div>
      );
    }

    return (
      <div ref={ref} className={baseClasses} {...props}>
        {children}
      </div>
    );
  }
);

const CardHeader = forwardRef<HTMLDivElement, CardHeaderProps>(
  ({ className, divider = true, children, ...props }, ref) => {
    const headerClasses = clsx(
      'px-6 py-4',
      {
        'border-b border-gray-200': divider,
      },
      className
    );

    return (
      <div ref={ref} className={headerClasses} {...props}>
        {children}
      </div>
    );
  }
);

const CardContent = forwardRef<HTMLDivElement, CardContentProps>(
  ({ className, padding = 'md', children, ...props }, ref) => {
    const contentClasses = clsx(
      {
        'p-0': padding === 'none',
        'px-3 py-2': padding === 'sm',
        'px-6 py-4': padding === 'md',
        'px-6 py-6': padding === 'lg',
        'px-8 py-8': padding === 'xl',
      },
      className
    );

    return (
      <div ref={ref} className={contentClasses} {...props}>
        {children}
      </div>
    );
  }
);

const CardFooter = forwardRef<HTMLDivElement, CardFooterProps>(
  (
    { 
      className, 
      divider = true, 
      background = 'muted', 
      children, 
      ...props 
    }, 
    ref
  ) => {
    const footerClasses = clsx(
      'px-6 py-4',
      {
        'border-t border-gray-200': divider,
        'bg-gray-50': background === 'muted',
        'bg-white': background === 'default',
      },
      className
    );

    return (
      <div ref={ref} className={footerClasses} {...props}>
        {children}
      </div>
    );
  }
);

Card.displayName = 'Card';
CardHeader.displayName = 'CardHeader';
CardContent.displayName = 'CardContent';
CardFooter.displayName = 'CardFooter';

export { Card, CardHeader, CardContent, CardFooter };
export default Card;