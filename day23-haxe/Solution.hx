using Lambda;
using StringTools;

enum Operand {
  Value(value: Int);
  Register(register: String);
}

enum OpCode {
  Set;
  Sub;
  Mul;
  Jnz;
}

typedef Command = {
    var opCode: OpCode;
    var operand1: Operand;
    var operand2: Operand;
}

class Solution {
  static var LAST_REG: Int = "h".charCodeAt(0);

  static function parseCommand(line: String): Command {
    function parseOperand(s): Operand {
      var val:Int = Std.parseInt(s);
      if (val == null) return Register(s);
      else return Value(val);
    }

    var parts = line.split(' ');
    var opCode = switch (parts[0]) {
      case "set": Set;
      case "sub": Sub;
      case "mul": Mul;
      case "jnz": Jnz;
      case _: throw 'Unknown command: ${parts[0]}';
    };

    return {
      opCode: opCode, 
      operand1: parseOperand(parts[1]), 
      operand2: parseOperand(parts[2])
    };
  }

  static function run(
    commands: Array<Command>, 
    initRegs: Map<String, Int>=null,
    countCalls: Bool=false, maxInstr: Int=-1) 
  {
    var regs = [
      for (reg in "a".charCodeAt(0)...LAST_REG + 1)
        String.fromCharCode(reg) => 0
    ];
    if (initRegs != null) {
      for (key in initRegs.keys()) regs[key] = initRegs[key];
    }

    function getVal(x: Operand): Int {
      return switch (x) {
        case Value(value): value;
        case Register(reg): regs[reg];
      }
    }

    var pos = 0;
    var i = 0;
    var callCount = [
      for (op in Type.allEnums(OpCode)) op => 0
    ];
    
    while (pos >= 0 && pos < commands.length) {
      if (maxInstr >= 0 && i == maxInstr) break;

      var cmd = commands[pos];
      switch [cmd.opCode, cmd.operand1] {
        case [Set, Register(reg)]: 
          regs[reg] = getVal(cmd.operand2);
        case [Sub, Register(reg)]:
          regs[reg] = getVal(cmd.operand1) - getVal(cmd.operand2);  
        case [Mul, Register(reg)]:
          regs[reg] = getVal(cmd.operand1) * getVal(cmd.operand2);  
        case [Jnz, _]: {
            var x = getVal(cmd.operand1);
            if (x != 0) {
              pos += getVal(cmd.operand2) - 1;
            }
          }
        case _: throw 'Invalid command: $cmd';
      }

      callCount[cmd.opCode] += 1;
      pos += 1;
      i += 1;
    }

    return {callCount: callCount, regs: regs};
  }

  static function isPrime(n: Int): Bool {
    var k = 2;
    while (k*k < n) {
      if (n%k == 0) return false;
      k += 1;
    }
    return true;
  }

  static function manuallyOptimizedProc(b: Int, c: Int, step: Int): Int {
    // We somehow manually inferred form the input program that it 
    // always counts the number of non-primes in form
    // x = b + kP, x <= c, k = 0,1,2,3...
    // and expect the input program to only differ in terms of (b, c, P)
    var res = 0;
    var i = b;
    while (i <= c) {
      if (!isPrime(i)) res += 1;
      i += step;
    }
    return res;
  }

  static function runPart2(commands: Array<Command>) {
    var res = run(commands, ["a" => 1], false, 100);
    var b = res.regs["b"];
    var c = res.regs["c"];
    function isMutatingB(cmd: Command): Bool {
      return cmd.opCode == Sub && Type.enumEq(cmd.operand1, Register("b"));
    }
    var mutb = commands.filter(isMutatingB);
    var step = switch (mutb[mutb.length - 1].operand2) {
      case Value(val): -val;
      case _: throw "Unexpected b mutation command";
    }

    return manuallyOptimizedProc(b, c, step);
  }
  
  static public function main(): Void {
    var commands = sys.io.File
      .getContent('input.txt')
      .trim()
      .split('\n')
      .map(parseCommand);

    var res = run(commands, null, true);
    Sys.println('Part1: ${res.callCount[Mul]}');
    Sys.println('Part2: ${runPart2(commands)}');
  }
}