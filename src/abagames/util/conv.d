module abagames.util.conv;

import std.stdio;
import abagames.util.math;

string convString(int v) {
  if (v == 0) {
    return "0";
  }
  bool isNegative = false;
  if (v < 0) {
    isNegative = true;
    v = -v;
  }
  string result;
  while (v != 0) {
    result = ((v % 10) + '0') ~ result;
    v = v / 10;
  }
  if (isNegative) {
    result = '-' ~ result;
  }
  return result;
}

int convInt(string str) {
  bool isNegative = false;
  int i = 0;
  if (str[i] == '-') {
    isNegative = true;
    i++;
  }
  int result = 0;
  while (i < str.length) {
    result = result * 10 + (str[i] - '0');
    i++;
  }
  if (isNegative) {
    result = -result;
  }
  return result;
}

// https://github.com/j949wang/StringToFloat
float convFloat(string input) {
    float maximum = float.max;
    float minimum = -float.max;
    int index = 0;
    float decimal = 0;
    int counter = 0;
    bool has_sign = false;
    bool is_negative = false;
    float value = 0;

    while (input[index] != '.'){
        index++;
        if (index >= input.length) {
          break;
        }
    }

    if (input[0] == '+' || input[0] == '-'){
      for (int i = 1; i < index; i++){
        int digit = input[i] -'0';
        if (input[1]-'0' == 0){
          value = 0;
          break;
        }
        maximum -= digit*pow(10,(index-1-i));
        minimum -= digit*pow(10,(index-1-i));
        if (maximum <0 || minimum >0){
          assert(false);
        }
        if (digit >= 0 && digit <= 9){
          value += digit*pow(10,(index-1-i));
        }
        else{
          assert(false);
        }
      }
      if (input[0] =='-'){
        is_negative = true;
        value *= -1;
      }
    }

    else{
      for (int i =0; i<index; i++){
        int digit = input[i]-'0';
        if (input[0]-'0' == 0){
          value = 0;
          break;
        }
        maximum -= digit*pow(10,(index-1-i));
        minimum -= digit*pow(10,(index-1-i));
        if (maximum <0 || minimum >0){
          assert(false);
        }
        if (digit >= 0 && digit <= 9){
          value += digit*pow(10,(index-1-i));
        }
        else{
          assert(false);
        }
      }
    }

    if (index < input.length && input[index] == '.') {
      index++;
      while (index < input.length) {
        int digit = input[index] - '0';
        if (digit >= 0 && digit <= 9){
          decimal = decimal * 10 + digit;
        }
        else{
          assert(false);
        }
        counter++;
        index++;
      }
    }

    decimal = decimal * pow(10, -counter);
    if (value < 0 || is_negative==true){
      value -=decimal;
    }
    else {
      value += decimal;
    }

    return value;
}
