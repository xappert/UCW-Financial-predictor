// Authentication removed for MVP - redirecting to home
import { useEffect } from 'react';
import { useRouter } from 'next/router';

const LoginPage = () => {
  const router = useRouter();
  
  useEffect(() => {
    router.push('/');
  }, [router]);

  return null;
};

export default LoginPage;