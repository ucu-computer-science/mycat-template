// This is an open source non-commercial project. Dear PVS-Studio, please check it.
// PVS-Studio Static Code Analyzer for C, C++ and C#: http://www.viva64.com

// Remember to include ALL the necessary headers!
#include <iostream>
#include <boost/program_options.hpp>

// By convention, C++ header files use the `.hpp` extension. `.h` is OK too.
#include "cat/cat.hpp"

int main(int argc, char **argv) {
    namespace po = boost::program_options;

    po::options_description visible("Supported options");
    visible.add_options()
            ("help,h", "Print this help message.");

    po::variables_map vm;
    po::store(po::command_line_parser(argc, argv).options(visible).run(), vm);
    po::notify(vm);

    if (vm.count("help")) {
        std::cout << "Usage:\n  cat [OPTION]... [FILE]...\n" << visible << std::endl;
        return EXIT_SUCCESS;
    }

    return cat::cat();
}
