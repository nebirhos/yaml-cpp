CXX = g++
AR = ar
LIBRARY = libyaml-cpp.a
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

all: $(LIBRARY)

.cpp.o:
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

$(LIBRARY): $(OBJECTS)
	ar -cq $(LIBRARY) $(OBJECTS)

clean:
	rm -f $(LIBRARY) $(OBJECTS)
