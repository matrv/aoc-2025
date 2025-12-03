#include <limits.h>
#include <math.h>
#include <stdbool.h>
#include <stdio.h>

long numPlaces(long n) {
  if (n < 0)
    return numPlaces((n == LONG_MIN) ? LONG_MAX : -n);
  if (n < 10)
    return 1;
  return 1 + numPlaces(n / 10);
}

long calculateRange1(long start, long end) {
  long result = 0;
  for (long i = start; i <= end; i++) {
    long numberOfChars = numPlaces(i);
    if (numberOfChars % 2 != 0)
      continue;
    long halfNum = numberOfChars / 2;
    long half = pow((double)10, (double)halfNum);
    long half1 = i % half;
    long half2 = i / half;
    if (half1 == half2) {
      result += i;
    }
  }
  return result;
}

long calculateRange2(long start, long end) {
  long result = 0;
  for (long i = start; i <= end; i++) {
    long numberOfChars = numPlaces(i);
    bool skipRest = false;
    for (long j = 1; j <= numberOfChars / 2; j++) {
      if (numberOfChars % j != 0)
        continue;
      long num = i;
      bool areAllSame = true;
      long lastNum = -1;
      long half = pow((double)10, (double)(j));
      for (long k = 0; k < numberOfChars / j; k++) {
        long newNum = num % half;
        if (lastNum != -1 && lastNum != newNum) {
          areAllSame = false;
        }
        lastNum = newNum;
        num /= half;
      }
      if (areAllSame) {
        result += i;
        break;
      }
    }
  }
  return result;
}

int main() {
  FILE *file = fopen("input.txt", "r");
  if (file == NULL) {
    printf("File not found");
    return 1;
  }
  int c;
  long firstNum = 0;
  long secondNum = 0;
  bool isReadingFirstNum = true;
  long result1 = 0;
  long result2 = 0;
  while ((c = fgetc(file)) != EOF) {
    if (c == '-') {
      isReadingFirstNum = false;
      continue;
    } else if (c == ',') {
      result1 += calculateRange1(firstNum, secondNum);
      result2 += calculateRange2(firstNum, secondNum);
      secondNum = 0;
      firstNum = 0;
      isReadingFirstNum = true;
      continue;
    } else if (c == '\n') {
      continue;
    }
    if (isReadingFirstNum) {
      firstNum = firstNum * 10 + c - '0';
    } else {
      secondNum = secondNum * 10 + c - '0';
    }
  }
  result1 += calculateRange1(firstNum, secondNum);
  result2 += calculateRange2(firstNum, secondNum);
  printf("Part 1 answer: %ld\n", result1);
  printf("Part 2 answer: %ld\n", result2);
  return 0;
}
