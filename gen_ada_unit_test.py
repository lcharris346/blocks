import os
import re
import sys


def generate_raw_tests(ads_file_path):
    if not os.path.exists(ads_file_path):
        print(f"Error: File '{ads_file_path}' not found.")
        return

    # Extract base file and package name
    base_name = os.path.splitext(os.path.basename(ads_file_path))[0]

    # Case-insensitive regex for Ada 83 subprograms
    proc_pattern = re.compile(
        r"^\s*procedure\s+([a-zA-Z0-9_]+)", re.IGNORECASE
    )
    func_pattern = re.compile(r"^\s*function\s+([a-zA-Z0-9_]+)", re.IGNORECASE)

    subprograms = []

    # Parse the spec file
    with open(ads_file_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            # Strip comments
            clean_line = line.split("--")[0].strip()

            proc_match = proc_pattern.match(clean_line)
            if proc_match:
                subprograms.append(("procedure", proc_match.group(1)))
                continue

            func_match = func_pattern.match(clean_line)
            if func_match:
                subprograms.append(("function", func_match.group(1)))

    if not subprograms:
        print(f"No subprograms found in {ads_file_path}.")
        return

    output_file = f"test_{base_name.lower()}.adb"

    # Generate standalone test code using only Text_IO
    with open(output_file, "w", encoding="utf-8") as out:
        out.write(f"with Text_IO;\n")
        out.write(f"with {base_name};\n\n")
        out.write(f"procedure Test_{base_name} is\n")
        out.write(
            f"   -- Standalone Ada 83 unit test harness (No external dependencies)\n\n"
        )

        # Generate individual test isolation routines
        for stype, name in subprograms:
            out.write(f"   procedure Test_{name} is\n")
            out.write(f"   begin\n")
            out.write(f"      Text_IO.Put_Line (\"Running Test_{name}...\");\n")
            out.write(
                f"      -- TODO: Initialize parameters and test {base_name}.{name}\n"
            )
            out.write(f"      pragma Assert (True);\n")
            out.write(f"      Text_IO.Put_Line (\"   PASSED\");\n")
            out.write(f"   exception\n")
            out.write(f"      when others =>\n")
            out.write(
                f"         Text_IO.Put_Line (\"   FAILED: Unhandled exception or Assert violation\");\n"
            )
            out.write(f"   end Test_{name};\n\n")

        # Driver execution block
        out.write(f"begin\n")
        out.write(
            f"   Text_IO.Put_Line (\"=== Starting Tests for {base_name} ===\");\n\n"
        )
        for _, name in subprograms:
            out.write(f"   Test_{name};\n")
        out.write(
            f"\n   Text_IO.Put_Line (\"=== Tests Completed ===\");\n"
        )
        out.write(f"end Test_{base_name};\n")

    print(f"Successfully generated independent test harness: {output_file}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python gen_raw_ada_tests.py <path_to_package_spec.ads>")
    else:
        generate_raw_tests(sys.argv[1])
