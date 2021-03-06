#ifndef COMMON_WUANALYSIS_ANAERRORCODES_HPP_
#define COMMON_WUANALYSIS_ANAERRORCODES_HPP_

#include "errorlist.h"

typedef enum
{
    ANA_GENERICERROR_ID=CONFIG_MGR_ERROR_START,
    ANA_DISTRIB_SKEW_INPUT_ID,
    ANA_DISTRIB_SKEW_OUTPUT_ID,
    ANA_IOSKEW_RECORDS_ID,
    ANA_UNUSED_ID,                                 /* May re-use but don't remove to avoid changing later id's */
    ANA_KJ_EXCESS_PREFILTER_ID
} AnalyzerErrorCode;

#endif /* COMMON_WUANALYSIS_ANAERRORCODES_HPP_ */
