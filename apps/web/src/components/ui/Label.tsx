import * as React from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '@/lib/utils';

const labelVariants = cva(
  'block font-medium transition-colors',
  {
    variants: {
      variant: {
        default: 'text-gray-700 dark:text-gray-300',
        error: 'text-red-600 dark:text-red-400',
      },
      size: {
        sm: 'text-sm mb-1',
        md: 'text-base mb-1.5',
        lg: 'text-lg mb-2',
      },
    },
    defaultVariants: {
      variant: 'default',
      size: 'md',
    },
  }
);

export interface LabelProps
  extends React.LabelHTMLAttributes<HTMLLabelElement>,
    VariantProps<typeof labelVariants> {
  required?: boolean;
}

const Label = React.forwardRef<HTMLLabelElement, LabelProps>(
  ({ className, variant, size, ...props }, ref) => {
    return (
      <label
        className={cn(labelVariants({ variant, size, className }), {
          "after:content-['*'] after:ml-0.5 after:text-red-500": props.required
        })}
        ref={ref}
        {...props}
      />
    );
  }
);
Label.displayName = 'Label';

export { Label };