module abagames.util.bytebuffer;

class ByteBuffer
{
public:
    ubyte[] data;

    void put(const ubyte[] b)
    {
        data ~= b;
    }
}
