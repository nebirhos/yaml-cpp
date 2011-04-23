CXX = g++
AR = ar
LIBRARY = libyaml-cpp.a
TEST    = yaml-cpp-test
SOURCES = src/aliasmanager.cpp \
          src/conversion.cpp \
          src/directives.cpp \
          src/emitfromevents.cpp \
          src/emitter.cpp \
          src/emitterstate.cpp \
          src/emitterutils.cpp \
          src/exp.cpp \
          src/iterator.cpp \
          src/nodebuilder.cpp \
          src/node.cpp \
          src/nodeownership.cpp \
          src/null.cpp \
          src/ostream.cpp \
          src/parser.cpp \
          src/regex.cpp \
          src/scanner.cpp \
          src/scanscalar.cpp \
          src/scantag.cpp \
          src/scantoken.cpp \
          src/simplekey.cpp \
          src/singledocparser.cpp \
          src/stream.cpp \
          src/tag.cpp
OBJECTS = $(SOURCES:.cpp=.o)
CPPFLAGS += -Iinclude/
CXXFLAGS += -Wall

TEST_SOURCES = $(wildcard test/*.cpp)
TEST_OBJECTS = $(TEST_SOURCES:.cpp=.o)

all: $(LIBRARY)

test: $(TEST)

.cpp.o:
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

$(LIBRARY): $(OBJECTS)
	ar -cq $(LIBRARY) $(OBJECTS)
	ranlib $(LIBRARY)

$(TEST): $(LIBRARY) $(TEST_OBJECTS)
	$(CXX) -o $(TEST) $(TEST_OBJECTS) $(LIBRARY)

clean: clean-test
	rm -f $(LIBRARY) $(OBJECTS)

clean-test:
	rm -f $(TEST_OBJECTS)
