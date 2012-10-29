#include <bindings.dsl.h>
#include <potracelib.h>

-- | See the Potrace API documentation at <http://potrace.sourceforge.net/potracelib.pdf>.

module Bindings.Potrace where
#strict_import

-- tracing parameters

#num POTRACE_TURNPOLICY_BLACK
#num POTRACE_TURNPOLICY_WHITE
#num POTRACE_TURNPOLICY_LEFT
#num POTRACE_TURNPOLICY_RIGHT
#num POTRACE_TURNPOLICY_MINORITY
#num POTRACE_TURNPOLICY_MAJORITY
#num POTRACE_TURNPOLICY_RANDOM

#starttype struct potrace_progress_s
#field callback , FunPtr (CDouble -> Ptr () -> IO ())
#field data , Ptr ()
#field min , CDouble
#field max , CDouble
#field epsilon , CDouble
#stoptype
#synonym_t potrace_progress_t , <struct potrace_progress_s>

#starttype struct potrace_param_s
#field turdsize , CInt
#field turnpolicy , CInt
#field alphamax , CDouble
#field opticurve , CInt
#field opttolerance , CDouble
#field progress , <potrace_progress_t>
#stoptype
#synonym_t potrace_param_t , <struct potrace_param_s>

-- bitmaps

#synonym_t potrace_word , CULong

#starttype struct potrace_bitmap_s
#field w , CInt
#field h , CInt
#field dy , CInt
#field map , Ptr <potrace_word>
#stoptype
#synonym_t potrace_bitmap_t , <struct potrace_bitmap_s>

-- curves

#starttype struct potrace_dpoint_s
#field x , CDouble
#field y , CDouble
#stoptype
#synonym_t potrace_dpoint_t , <struct potrace_dpoint_s>

#num POTRACE_CURVETO
#num POTRACE_CORNER

#starttype struct potrace_curve_s
#field n , CInt
#field tag , Ptr CInt
#field c , Ptr <potrace_dpoint_t>
-- | NB: `c` is actually a pointer to array 3 of `potrace_dpoint_t`!  To access C's `c[n][i]` use instead offset `3 * n + i`.
#stoptype
#synonym_t potrace_curve_t , <struct potrace_curve_s>

#opaque_t struct potrace_privpath_s

#starttype struct potrace_path_s
#field area , CInt
#field sign , CInt
#field curve , <potrace_curve_t>
#field next , Ptr <struct potrace_path_s>
#field childlist , Ptr <struct potrace_path_s>
#field sibling , Ptr <struct potrace_path_s>
#field priv , Ptr <struct potrace_privpath_s>
#stoptype
#synonym_t potrace_path_t , <struct potrace_path_s>

-- Potrace state

#num POTRACE_STATUS_OK
#num POTRACE_STATUS_INCOMPLETE

#opaque_t struct potrace_privstate_s

#starttype struct potrace_state_s
#field status , CInt
#field plist , Ptr <potrace_path_t>
#field priv , Ptr <struct potrace_privstate_s>
#stoptype
#synonym_t potrace_state_t , <struct potrace_state_s>

-- API functions

#ccall potrace_param_default , IO (Ptr <potrace_param_t>)
#ccall potrace_param_free , Ptr <potrace_param_t> -> IO ()
#ccall potrace_trace , Ptr <potrace_param_t> -> Ptr <potrace_bitmap_t> -> IO (Ptr <potrace_state_t>)
#ccall potrace_state_free , Ptr <potrace_state_t> -> IO ()
#ccall potrace_version , IO CString
