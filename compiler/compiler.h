// compiler.h
#ifndef COMPILER_H
#define COMPILER_H

#include <json-c/json.h>

// Declare tokens_array globally
extern struct json_object *tokens_array;

void write_tokens_to_json(); // Declare function to write tokens to JSON file

#endif
