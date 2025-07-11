// Authentication removed for MVP - redirecting to home
import { useEffect } from 'react';
import { useRouter } from 'next/router';

const SignupPage = () => {
  const router = useRouter();
  
  useEffect(() => {
    router.push('/');
  }, [router]);

  return null;
};

export default SignupPage;