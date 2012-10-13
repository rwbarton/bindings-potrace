module Demo where

import Control.Monad (when)

import Foreign (newArray, new, free, peek, nullPtr)
import Foreign.C.String (peekCAString)
import Foreign.C.Error (Errno(..), getErrno)

import Bindings.Potrace

main = do
  ver <- peekCAString =<< c'potrace_version
  putStrLn $ "Using library " ++ ver
  params <- c'potrace_param_default
  bits <- newArray [
    0x0010fc7f, 0xf0000000,
    0x0031fe7f, 0xf0000000,
    0x0073ff3f, 0xe0000000,
    0x00f7ffbf, 0xe0000000,
    0x01f7cf9f, 0xc0000000,
    0x03f7879f, 0xc0000000,
    0x07f7878f, 0x80000000,
    0x0ff7cf8f, 0x80000000,
    0x1ff7ff87, 0x00000000,
    0x3ff3ff07, 0x00000000,
    0x7ff1fe02, 0x00000000,
    0xfff0fc02, 0x00000000
    ]
  bitmap <- new C'potrace_bitmap_s {
    c'potrace_bitmap_s'w = 36,
    c'potrace_bitmap_s'h = 12,
    c'potrace_bitmap_s'dy = 2,
    c'potrace_bitmap_s'map = bits
    }
  state <- c'potrace_trace params bitmap
  if state /= nullPtr
    then do
    C'potrace_state_s status plist _priv <- peek state
    if status == c'POTRACE_STATUS_OK
      then do
      putStrLn "Success."
      let loop pptr = when (pptr /= nullPtr) $ do
            p <- peek pptr
            print p
            loop $ c'potrace_path_s'next p
      loop plist
      else putStrLn "potrace failed: status not POTRACE_STATUS_OK."
    else do
    Errno errno <- getErrno
    putStrLn $ "potrace failed; errno = " ++ show errno ++ "."
  c'potrace_state_free state
  free bitmap
  c'potrace_param_free params
