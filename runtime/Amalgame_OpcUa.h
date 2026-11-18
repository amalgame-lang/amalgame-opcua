/* Amalgame_OpcUa.h — runtime header for the amalgame-opcua package.
 * Forward declarations only : the implementation lives in the @c
 * block of facade.am (with the open62541 amalgamation it includes),
 * compiled into libamalgame-pkg-OpcUa.a.
 *
 *   import Amalgame.OpcUa
 */

#ifndef AMALGAME_OPCUA_H
#define AMALGAME_OPCUA_H

#include "_runtime.h"
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Client */
int64_t     Amalgame_OpcUa_OpcUa_Connect(code_string url, int64_t timeoutMs);
void        Amalgame_OpcUa_OpcUa_Close(int64_t h);
code_bool   Amalgame_OpcUa_OpcUa_IsConnected(int64_t h);
code_string Amalgame_OpcUa_OpcUa_LastError(int64_t h);
int64_t     Amalgame_OpcUa_OpcUa_ReadMany(int64_t h, code_string nodeIds);
double      Amalgame_OpcUa_OpcUa_Value(int64_t h, int64_t i);
int64_t     Amalgame_OpcUa_OpcUa_Status(int64_t h, int64_t i);
code_string Amalgame_OpcUa_OpcUa_StatusName(int64_t code);
code_string Amalgame_OpcUa_OpcUa_BrowseTree(int64_t h, code_string root, int64_t maxDepth, int64_t maxNodes);

/* Server (tests, demos) */
code_bool   Amalgame_OpcUa_OpcUa_ServerStart(int64_t port);
code_bool   Amalgame_OpcUa_OpcUa_ServerAddAnalog(code_string folder, code_string name, double value, double lo, double hi, code_string unit);
code_bool   Amalgame_OpcUa_OpcUa_ServerAddInt(code_string folder, code_string name, int64_t value);
code_bool   Amalgame_OpcUa_OpcUa_ServerSet(code_string nodeId, double value);

#ifdef __cplusplus
}
#endif
#endif
