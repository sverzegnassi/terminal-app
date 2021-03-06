#include "fileio.h"

FileIO::FileIO()
{
}

bool FileIO::write(const QString& sourceUrl, const QString& data) {
    if (sourceUrl.isEmpty())
        return false;

    QFile file(sourceUrl);
    if (!file.open(QFile::WriteOnly | QFile::Truncate))
        return false;

    QTextStream out(&file);
    out << data;
    file.close();
    return true;
}

QString FileIO::read(const QString& sourceUrl) {
    if (sourceUrl.isEmpty())
        return "";

    QFile file(sourceUrl);
    if (!file.open(QFile::ReadOnly))
        return "";

    QTextStream in(&file);
    QString result = in.readAll();

    file.close();

    return result;
}
