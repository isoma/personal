/*
  gcc -fPIC -c cffi_callback_test.c 
  gcc -shared -Wl,-soname,libcbtest.so.1 -o libcbtest.so.1.0 cffi_callback_test.o

  sudo cp libcbtest.so.1.0  /usr/lib/.

  ldd /usr/lib/libcbtest.so.1.0
  nm /usr/lib/libcbtest.so.1.0

 */


typedef void (*CvTrackbarCallback)(int pos);

/* create trackbar and display it on top of given window, set callback */
int testCreateTrackbar( const char* trackbar_name, const char* window_name,
                      int* value, int count, CvTrackbarCallback on_change );


typedef void (*CvTrackbarCallback2)(int pos, void* userdata);

int testCreateTrackbar2( const char* trackbar_name, const char* window_name,
                       int* value, int count, CvTrackbarCallback2 on_change,
                       void* userdata );


int test_cffi_cb0 (int c) {
  return c + 8;
}

int test_cffi_cb1 (int c, int (* function)(int i)) {
  return function( c + 2 );
}

int test_cffi_cb2 (int c, void (* function)(int i)) {
  function( 22 );
  return 55;
}

int testCreateTrackbar( const char* trackbar_name, const char* window_name,
                        int* value, int count, CvTrackbarCallback on_change ) {
  on_change(20); 
  return count;
}


int testCreateTrackbar2( const char* trackbar_name, const char* window_name,
                         int* value, int count, CvTrackbarCallback2 on_change,
                         void* userdata ) {
  on_change(20, 0);
  return count;
}


/*
 ps -ax | grep sbcl
 pmap 2496 | grep cbtest
 */
